classdef Map_Update < ESTIMATOR_CLASS
    properties
        result
        env
        self
    end
    
    methods
        function obj = Map_Update(self,param)
            obj.self = self;
        end
        
        function [result]=do(obj,param,varargin)
            % param
            % varargin : 他の推定器で推定した状態
            sensor = obj.self.sensor.result;
            env = obj.self.env.(obj.self.env.name(1));
            if ~isempty(varargin)
                state = varargin{1}.state;
            else
                state = sensor.state;
            end
            pos=[find((env.param.xq(:,1)>(state.p(1)-env.param.d/2)),1),find((env.param.yq(1,:)>(state.p(2)-env.param.d/2)),1)]; % globalのgrid 上のエージェントの位置
            [~,rmin_pos(1)] = min(abs(sensor.xq(:,1)));
            [~,rmin_pos(2)]=min(abs(sensor.yq(1,:))); % local grid 上のエージェントの位置
            min_pos=pos-rmin_pos+[1 1]; % センサー計測値のglobal grid上の開始位置
            map_size=size(sensor.xq)-[1 1]; % 計測したmapのgridサイズ
            env.param.grid_density(min_pos(1):min_pos(1)+map_size(1),min_pos(2):min_pos(2)+map_size(2))=env.param.grid_density(min_pos(1):min_pos(1)+map_size(1),min_pos(2):min_pos(2)+map_size(2)).*(sensor.grid_density==0) + sensor.grid_density;
            obj.result= env;
            result=obj.result;
            obj.env = env;
        end
        function show(obj)
            obj.env.show()
        end
    end
end

