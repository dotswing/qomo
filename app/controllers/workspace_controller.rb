require 'rgl/adjacency'
require 'rgl/topsort'

class WorkspaceController < ApplicationController

  def index
    @groups = ToolGroup.all
    @action = flash[:action]
    @pid = flash[:pid]
  end


  def run
    preset = {}
    preset['STREAMING_JAR'] = Settings.lib_path Settings.lib.streaming
    preset['QOMO_COMMON'] = Settings.lib_path Settings.lib.common
    preset['HADOOP_BIN'] = Settings.hadoop.bin

    env = {}
    env['HADOOP_USER_NAME'] = Settings.hdfs.web.user

    boxes = JSON.parse params['boxes']
    conns = JSON.parse params['connections']

    dg=RGL::DirectedAdjacencyGraph.new
    conns.each do |e|
      dg.add_edge e['sourceId'], e['targetId']

      if boxes[e['sourceId']]['values'][e['sourceParamName']].blank?
        boxes[e['sourceId']]['values'][e['sourceParamName']] = "tmp-#{SecureRandom.uuid}"
      end
      pp boxes[e['sourceId']]['values']
      boxes[e['targetId']]['values'][e['targetParamName']] = boxes[e['sourceId']]['values'][e['sourceParamName']]
    end

    units = {}

    boxes.each do |k, v|
      tool = Tool.find v['tid']
      command = tool.command
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
            if %w(input output).include? e['type']
              va = hdfs.apath uid, va
            end
          end
        end

        command.gsub! /\#{#{ka}}/, va.to_s
      end

      command = "#{command}"
      units[k] = {id: k, tid: tool.id, command: command, wd: tool.dirpath, env: env}
    end

    ordere_units = dg.topsort_iterator.to_a.collect {|e| units[e]}

    engine.job_submit uid, MultiJson.encode(ordere_units)

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


end
