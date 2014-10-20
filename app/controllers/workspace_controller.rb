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

    output_prefix = File.join uid, job_output_dir(jid)
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
      v['values'].each do |ka, va|
        tool.params.each do |e|
          if e['name'] == ka and e['type'] == 'output'
            if va.blank?
              boxes[k]['values'][ka] = File.join '.tmp', SecureRandom.uuid
            else
              boxes[k]['values'][ka] = File.join job_output_dir(jid), va
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
                va = hdfs.apath uid, va
              when 'output'
                va = hdfs.apath uid, va
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
    flash[:action] = 'load'
    flash[:pid] = params['id']
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
