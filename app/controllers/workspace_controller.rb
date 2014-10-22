require 'rgl/adjacency'
require 'rgl/topsort'

class WorkspaceController < ApplicationController

  def index
    @groups = ToolGroup.all
    @action = flash[:action]
    @pid = flash[:pid]
  end


  def run
    #Job id
    jid = SecureRandom.uuid

    output_prefix = hdfs.upath uid, job_output_dir(jid)
    hdfs.mkdir output_prefix

    preset = {}
    preset['STREAMING_JAR'] = Settings.lib_path Settings.lib.streaming
    preset['QOMO_COMMON'] = Settings.lib_path Settings.lib.common
    preset['HADOOP_BIN'] = Settings.hadoop.bin

    env = {}
    env['HADOOP_USER_NAME'] = Settings.hdfs.web.user

    boxes = JSON.parse params['boxes']
    conns = JSON.parse params['connections']

    units = {}

    #Fill the blank output param
    boxes.each do |k, v|
      tool = Tool.find v['tid']

      tool.params.each do |e|
        if e['type'] == 'tmp'
          boxes[k]['values'][e['name']] = File.join '.tmp', SecureRandom.uuid
        end

        v['values'].each do |ka, va|
          if e['name'] == ka
            if e['type'] == 'output'
              if va.blank?
                boxes[k]['values'][ka] = File.join '.tmp', SecureRandom.uuid
              else
                boxes[k]['values'][ka] = File.join job_output_dir(jid), va
              end
            end
          end
        end
      end
    end

    #Copy output param to input param for connected tools
    dg=RGL::DirectedAdjacencyGraph.new
    conns.each do |e|
      dg.add_edge e['sourceId'], e['targetId']
      boxes[e['targetId']]['values'][e['targetParamName']] = boxes[e['sourceId']]['values'][e['sourceParamName']]
    end

    #Generate commands
    boxes.each do |k, v|
      tool = Tool.find v['tid']
      command = tool.command.dup
      pp command

      preset.merge(v['values']).each do |ka, va|
        if va.kind_of? Array
          separator = ''
          tool.params.each do |p|
            separator = p['separator'] if p['name'] == ka
          end
          va = va.join separator
        end

        tool.params.each do |e|
          if e['name'] == ka
            case e['type']
              when 'input'
                va = hdfs.uapath uid, va
              when 'output'
                va = hdfs.uapath uid, va
              when 'tmp'
                va = hdfs.uapath uid, va
            end

          end
        end

        command.gsub! /\#{#{ka}}/, va.to_s
      end

      units[k] = {id: k, tid: tool.id, command: command, wd: tool.dirpath, env: env}
    end

    ordere_units = dg.topsort_iterator.to_a

    if ordere_units.length == 0
      ordere_units = units.values
    else
      ordere_units = ordere_units.collect {|e| units[e]}
    end

    engine.job_submit uid, jid, MultiJson.encode(ordere_units)

    render json: {success: true}
  end


  def load
    pipeline = Pipeline.find params['id']
    if pipeline.owner.id != current_user.id
      my_pipeline = Pipeline.new title: 'My ' + pipeline.title,
                                 desc: pipeline.desc,
                                 boxes: pipeline.boxes,
                                 connections: pipeline.connections,
                                 params: pipeline.params,
                                 owner_id: current_user.id

      my_pipeline.save
      pipeline = my_pipeline
    end

    flash[:action] = 'load'
    flash[:pid] = pipeline.id
    redirect_to action: 'index'
  end


  def merge
    flash[:action] = 'merge'
    flash[:pid] = params['id']
    redirect_to action: 'index'
  end


  protected

  def job_output_dir(jid)
    "job-#{jid}"
  end


end
