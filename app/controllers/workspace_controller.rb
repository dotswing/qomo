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
    env['HADOOP_USER_NAME'] = Settings.hdfs.user

    boxes = JSON.parse params['boxes']
    conns = JSON.parse params['connections']
    units = {}
    pp boxes
    pp conns

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
        if %w(input output).include? ka
          va = hdfs.rpath uid, va
        end
        command.gsub! /\#{#{ka}}/, va.to_s
      end

      command = "#{command}"
      units[k] = {id: k, command: command, wd: tool.dirpath, env: env}
    end
    pp units

    engine.job_submit MultiJson.encode(units.values)

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
