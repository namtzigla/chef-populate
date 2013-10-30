#
# Cookbook Name:: populate
# Recipe:: default
#
# Copyright (C) 2013 Florin STAN
#
# All rights reserved - Do Not Redistribute
#


chef_gem 'pry' do
	action :install
end


require 'pry'

ruby_block "run populate queries" do
  block do
    Chef::Log.info ("Executing queries ....")

    node[:populate][:queries].each do |q|
      res = search(q[:index], q[:query]).map do |e|
        q[:fields].map do |f|
          if f[:append].nil?
            e[f[:name]]
          else
            "#{e[f[:name]]}#{f[:append]}"
          end
        end
      end
      Chef::Log.info res
      if res != nil
        if q[:mapping] == nil
          eval "#{q[:dest]} = res"
        else
          eval "#{q[:dest]} = res#{q[:mapping]}"
        end
      end
    end
    
    Chef::Log.info node if node[:populate][:verbose] != nil and node[:populate][:verbose]
    
  end
  action :create
end
