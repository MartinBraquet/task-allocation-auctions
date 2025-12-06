%% Decentralized Control for Dynamic Task Allocation Problems for Multi-Agent Systems with Auctions
% Analysis of the variation of the parameters
%
% Author: Martin Braquet
% Date: November 2020

function [] = optimalControlParametersAnalysis()

addpath('GreedyCoalitionAuctionAlgorithm/');
close all; clear all;
rng('default');
rng(6);

simuNumber = 3;
simuName = 'Variation of parameters';

%% Setting of the manual parameters

AllParamsToAnalyze = {'RangeLimitation', 'RewardSuccessProbability', 'NumberAgentsTasks', 'TimeRatioLoiteringTasks'};
paramToAnalyze = AllParamsToAnalyze{3};

isUniformAgents = 0;
isUniformTasks = 1;
isPlotAlloc = 0;
isPlotRange = 0;
isCommLimit = 0;

nA = 10;
nT = 20;
ntLoiter = 0; %ceil(0.5*nt);
ratioRangeMapWidth = 0.3;
nRounds = 50;
maxInitSpeedAgents = 0.1;
nomReward = 1;
nomProbAT = 0.5;


%% Setting of the fixed parameters

lambda = 1;
Lt = 1;

mapWidth = 1;
commDistance = ratioRangeMapWidth * mapWidth;

simuTime = 10;
timeStep = simuTime / nRounds;

posA = (0.1 + 0.8 * rand(nA,2)) * mapWidth;
posT = (0.1 + 0.8 * rand(nT,2)) * mapWidth;

tfT =  simuTime * ones(nT,1);
tlT =  0.2 * simuTime * ones(nT,1);
taskType = zeros(nT,1);
taskType(1:ntLoiter) = 1;
tlT(taskType == 0) = 0;
[tlT, idx] = sort(tlT);
posT = posT(idx,:);

% Drag force to slow down the agents, final speed set to exp(-3) * vA0
kdrag = 3 / simuTime;

if isUniformAgents
    vA = zeros(nA,2);
else
    vA = (2 * rand(nA,2) - 1) * maxInitSpeedAgents;
end

maxInitSpeedTasks = 0.1;
if isUniformTasks
    vT = zeros(nT,2);
else
    vT = (2 * rand(nT,2) - 1) * maxInitSpeedTasks;
end

R = 0.04 * mapWidth;
if isUniformTasks
    radiusT = R * ones(nT,1);
else
    radiusT = (0.2 * rand(nT,1) + 1) * R;
end

% Reward after task completion
if isUniformTasks
    rBar = nomReward * ones(nT,1);
else
    rBar = nomReward * rand(nT,1);
end
rBar(taskType == 1) = 2 * rBar(taskType == 1);

% Probability that agent i successfully completes task j
if isUniformAgents
    probAT = nomProbAT * ones(nA,nT);
else
    probAT = rand(nA,nT);
end

Tasks.Pos          = posT;
Tasks.Speed        = vT;
Tasks.N            = nT;
Tasks.tf           = tfT;
Tasks.lambda       = lambda;
Tasks.task_type    = taskType;
Tasks.tloiter      = tlT;
Tasks.radius       = radiusT;
Tasks.r_bar        = rBar;
Tasks.prob_a_t     = probAT;
Tasks.task_type    = taskType;

Agents.N                    = nA;
Agents.Lt                   = Lt * ones(1,nA);
Agents.Pos                = posA;
Agents.v_a                  = vA;
Agents.previous_task        = zeros(nA,1);
Agents.previous_winnerBids  = zeros(nA,1);
Agents.rin_task             = zeros(nA,2);
Agents.vin_task             = zeros(nA,2);
Agents.kdrag                = kdrag;

% Fully connected graph
G = ~eye(Agents.N);

if isPlotAlloc
    figure; hold on;
    colors = lines(nA);
    SimuParamsCell.colors          = colors;
end

SimuParamsCell.n_rounds            = nRounds;
SimuParamsCell.timeStep            = timeStep;
SimuParamsCell.mapWidth            = mapWidth;
SimuParamsCell.commDistance        = commDistance;
SimuParamsCell.simuTime            = simuTime;
SimuParamsCell.timeStep            = timeStep;
SimuParamsCell.posA                = posA;
SimuParamsCell.maxInitSpeedAgents  = maxInitSpeedAgents;
SimuParamsCell.vA                  = vA;
SimuParamsCell.posT                = posT;
SimuParamsCell.maxInitSpeedTasks   = maxInitSpeedTasks;
SimuParamsCell.vT                  = vT;
SimuParamsCell.radiusT             = radiusT;
SimuParamsCell.taskType            = taskType;
SimuParamsCell.ntLoiter            = ntLoiter;
SimuParamsCell.taskType            = taskType;
SimuParamsCell.na                  = nA;
SimuParamsCell.nt                  = nT;
SimuParamsCell.tfT                 = tfT;
SimuParamsCell.tlT                 = tlT;
SimuParamsCell.R                   = R;
SimuParamsCell.radiusT             = radiusT;
SimuParamsCell.nomReward           = nomReward;
SimuParamsCell.rBar                = rBar;
SimuParamsCell.lambda              = lambda;
SimuParamsCell.probAT              = probAT;
SimuParamsCell.kdrag               = kdrag;

%%

switch paramToAnalyze
    case 'RangeLimitation'
        analyzeUtilityRangeLimitation();
    case 'RewardSuccessProbability'
        analyzeUtilityRewardSuccessProbability();
    case 'NumberAgentsTasks'
        analyzeTimeNumberAgentsTasks();
    case 'TimeRatioLoiteringTasks'
        analyzeTimeRatioLoiteringTasks();
end

%% Main subfunctions

    function [] = analyzeUtilityRangeLimitation()
        
        % Setting of the varying parameters
        ratioRangeMapWidth = 0:0.01:1;
        commDistance = ratioRangeMapWidth * mapWidth;
        totalUtilityAllocation = zeros(length(ratioRangeMapWidth), 1);
        
        for k = 1:length(ratioRangeMapWidth)
            if isPlotAlloc
                plotMapAgentsTasks();
            end
            
            for i = 1:nA
                for j = (i+1):nA
                    G(i,j) = norm(posA(i,:) - posA(j,:)) < commDistance(k);
                    G(j,i) = G(i,j);
                end
            end
            
            % GCAA solution
            tic;
            [S_GCAA, pGCAA, ~, ~, Agents] = GCAASolution(Agents, G, Tasks);
            pGCAA
            toc;
            
            totalUtilityAllocation(k) = S_GCAA;
            
            if isPlotAlloc
                setPlotAllocation(pGCAA);
            end
        end
        
        mkdir(sprintf('mat/%s/%s/simu_%d', simuName, paramToAnalyze, simuNumber));
        save(sprintf('mat/%s/%s/simu_%d/ratioRangeMapWidth-%d.mat', simuName, paramToAnalyze, simuNumber), 'ratioRangeMapWidth');
        save(sprintf('mat/%s/%s/simu_%d/totalUtilityAllocation-%d.mat', simuName, paramToAnalyze, simuNumber), 'totalUtilityAllocation');
        save(sprintf('mat/%s/%s/simu_%d/SimuParamsCell.mat', simuName, paramToAnalyze, simuNumber), 'SimuParamsCell');
        
        figure;
        plot(ratioRangeMapWidth, totalUtilityAllocation);
        title('Total utility');
        
    end

    function [] = analyzeUtilityRewardSuccessProbability()
        
        % Setting of the varying parameters
        nomReward = 0:0.1:1;
        nomProbAT = 0:0.1:1;
        totalUtilityAllocation = zeros(length(nomReward), length(nomProbAT));
        
        for k = 2:length(nomReward)
            for l = 2:length(nomProbAT)
                
                rBar = nomReward(k) * ones(nT,1);
                Tasks.r_bar = rBar;
                probAT = nomProbAT(l) * ones(nA,nT);
                Tasks.prob_a_t = probAT;
                
                if isPlotAlloc
                    plotMapAgentsTasks();
                end
                
                if isCommLimit
                    setCommunicationLimitation();
                end
                
                % GCAA solution
                tic;
                [S_GCAA, pGCAA, ~, ~, Agents] = GCAASolution(Agents, G, Tasks);
                pGCAA
                toc;
                
                totalUtilityAllocation(k,l) = S_GCAA;
                
                if isPlotAlloc
                    setPlotAllocation(pGCAA);
                end
            end
        end
        
        mkdir(sprintf('mat/%s/%s/simu_%d', simuName, paramToAnalyze, simuNumber));
        save(sprintf('mat/%s/%s/simu_%d/nomReward-%d.mat', simuName, paramToAnalyze, simuNumber), 'nomReward');
        save(sprintf('mat/%s/%s/simu_%d/nomProbAT-%d.mat', simuName, paramToAnalyze, simuNumber), 'nomProbAT');
        save(sprintf('mat/%s/%s/simu_%d/totalUtilityAllocation-%d.mat', simuName, paramToAnalyze, simuNumber), 'totalUtilityAllocation');
        save(sprintf('mat/%s/%s/simu_%d/SimuParamsCell.mat', simuName, paramToAnalyze, simuNumber), 'SimuParamsCell');
        
        figure;
        [mechNomReward, meshNomProbAT] = meshgrid(nomReward, nomProbAT);
        surf(mechNomReward, meshNomProbAT, totalUtilityAllocation);
        xlabel('nomReward');
        ylabel('nomProbAT');
        title('Total utility');
        
    end

    function [] = analyzeTimeNumberAgentsTasks()
        
        % Setting of the varying parameters
        nAVect = 1:2:80;
        nTVect = 1:2:80;
        totalUtilityAllocation = zeros(length(nAVect), length(nTVect));
        totalComputationTime = zeros(length(nAVect), length(nTVect));
        
        for k = 1:length(nAVect)
            for l = 1:length(nTVect)
                
                nA = nAVect(k);
                nT = nTVect(l);
                
                posA = (0.1 + 0.8 * rand(nA,2)) * mapWidth;
                posT = (0.1 + 0.8 * rand(nT,2)) * mapWidth;
                tfT =  simuTime * ones(nT,1);
                tlT =  0.2 * simuTime * ones(nT,1);
                taskType = zeros(nT,1);
                taskType(1:ntLoiter) = 1;
                tlT(taskType == 0) = 0;
                [tlT, idx] = sort(tlT);
                posT = posT(idx,:);
                vA = zeros(nA,2);
                vT = zeros(nT,2);
                R = 0.04 * mapWidth;
                radiusT = R * ones(nT,1);
                rBar = nomReward * ones(nT,1);
                probAT = nomProbAT * ones(nA,nT);
                G = ~eye(nA);
                
                Tasks.Pos          = posT;
                Tasks.Speed        = vT;
                Tasks.N            = nT;
                Tasks.tf           = tfT;
                Tasks.lambda       = lambda;
                Tasks.task_type    = taskType;
                Tasks.tloiter      = tlT;
                Tasks.radius       = radiusT;
                Tasks.r_bar        = rBar;
                Tasks.prob_a_t     = probAT;
                Tasks.task_type    = taskType;
                
                Agents.N                    = nA;
                Agents.Lt                   = Lt * ones(1,nA);
                Agents.Pos                  = posA;
                Agents.v_a                  = vA;
                Agents.previous_task        = zeros(nA,1);
                Agents.previous_winnerBids  = zeros(nA,1);
                Agents.rin_task             = zeros(nA,2);
                Agents.vin_task             = zeros(nA,2);
                
                if isPlotAlloc
                    plotMapAgentsTasks();
                end
                
                if isCommLimit
                    setCommunicationLimitation();
                end
                
                % GCAA solution
                tic;
                [S_GCAA, pGCAA, ~, ~, Agents] = GCAASolution(Agents, G, Tasks);
                %pGCAA
                totalComputationTime(k,l) = toc;
                [k l]
                
                totalUtilityAllocation(k,l) = S_GCAA;
                
                if isPlotAlloc
                    setPlotAllocation(pGCAA);
                end
            end
        end
        
        mkdir(sprintf('mat/%s/%s/simu_%d', simuName, paramToAnalyze, simuNumber));
        save(sprintf('mat/%s/%s/simu_%d/nAVect-%d.mat', simuName, paramToAnalyze, simuNumber), 'nAVect');
        save(sprintf('mat/%s/%s/simu_%d/nTVect-%d.mat', simuName, paramToAnalyze, simuNumber), 'nTVect');
        save(sprintf('mat/%s/%s/simu_%d/totalUtilityAllocation-%d.mat', simuName, paramToAnalyze, simuNumber), 'totalUtilityAllocation');
        save(sprintf('mat/%s/%s/simu_%d/totalComputationTime-%d.mat', simuName, paramToAnalyze, simuNumber), 'totalComputationTime');
        save(sprintf('mat/%s/%s/simu_%d/SimuParamsCell.mat', simuName, paramToAnalyze, simuNumber), 'SimuParamsCell');
        
        [mechnAVect, meshnTVect] = meshgrid(nAVect, nTVect);
        
        figure;
        surf(mechnAVect, meshnTVect, totalUtilityAllocation);
        xlabel('nA');
        ylabel('nT');
        title('Total utility');
        
        figure;
        surf(mechnAVect, meshnTVect, totalComputationTime);
        xlabel('nA');
        ylabel('nT');
        title('Computation time');
        
    end

    function [] = analyzeTimeRatioLoiteringTasks()
        
        % Setting of the varying parameters
        ntLoiterVect = 0:nT;
        totalUtilityAllocation = zeros(length(ntLoiterVect+1), 1);
        totalComputationTime = zeros(length(ntLoiterVect+1), 1);
        
        for k = 1:length(ntLoiterVect)+1
            
            ntLoiter = ntLoiterVect(k);
            
            taskType(1:ntLoiter) = 1;
            tlT(taskType == 0) = 0;
            tlT(taskType == 1) = 2;
            Tasks.tloiter = tlT;
            Tasks.task_type = taskType;
        
            Agents.previous_task        = zeros(nA,1);
            Agents.previous_winnerBids  = zeros(nA,1);
            Agents.rin_task             = zeros(nA,2);
            Agents.vin_task             = zeros(nA,2);
            
            if isPlotAlloc
                plotMapAgentsTasks();
            end
            
            if isCommLimit
                setCommunicationLimitation();
            end
            
            % GCAA solution
            tic;
            [S_GCAA, pGCAA, ~, ~, Agents] = GCAASolution(Agents, G, Tasks);
            %pGCAA
            totalComputationTime(k) = toc;
            ntLoiter
            
            totalUtilityAllocation(k) = S_GCAA;
            
            if isPlotAlloc
                setPlotAllocation(pGCAA);
            end
        end
        
        mkdir(sprintf('mat/%s/%s/simu_%d', simuName, paramToAnalyze, simuNumber));
        save(sprintf('mat/%s/%s/simu_%d/ntLoiterVect-%d.mat', simuName, paramToAnalyze, simuNumber), 'ntLoiterVect');
        save(sprintf('mat/%s/%s/simu_%d/totalUtilityAllocation-%d.mat', simuName, paramToAnalyze, simuNumber), 'totalUtilityAllocation');
        save(sprintf('mat/%s/%s/simu_%d/totalComputationTime-%d.mat', simuName, paramToAnalyze, simuNumber), 'totalComputationTime');
        save(sprintf('mat/%s/%s/simu_%d/SimuParamsCell.mat', simuName, paramToAnalyze, simuNumber), 'SimuParamsCell');
       
        figure;
        plot(ntLoiterVect, totalUtilityAllocation);
        title('Total utility');
        
        figure;
        plot(ntLoiterVect, totalComputationTime);
        title('Computation time');
        
    end

%% Other subfunctions

    function [] = setCommunicationLimitation()
        
        for i = 1:nA
            for j = (i+1):nA
                G(i,j) = norm(posA(i,:) - posA(j,:)) < commDistance;
                G(j,i) = G(i,j);
            end
        end
        
    end

    function [] = setPlotAllocation(pGCAA)
        
        % Find the optimal control solution for the given allocation p_GCAA
        [X, ~, ~, ~] = OptimalControlSolution(posA, vA, posT, vT, radiusT, pGCAA, Agents, tfT, Tasks.tloiter, timeStep, nRounds, nA, kdrag);
        plotMapAllocation(X, nRounds, nA, colors, 'GCAA solution');
        legend(legendUnq(gca));
        drawnow;
        
    end


    function [] = plotMapAgentsTasks()
        
        clf; hold on;
        xlim([0 mapWidth]);
        ylim([0 mapWidth]);
        xlabel('x [m]');
        ylabel('y [m]');
        title('Task-Agent allocation');
        for i = 1:nA
            plot(posA(i,1), posA(i,2), '*', 'Color', colors(i,:), 'MarkerSize', 10, 'DisplayName', 'Agents');
        end
        plot(posT(:,1), posT(:,2),'rs', 'MarkerSize', 10, 'DisplayName', 'Targets', 'MarkerFaceColor',[1 .6 .6]);
        if isPlotRange
            PlotAgentRange(posA, commDistance, colors, 'Comm Range');
        end
        
        PlotTaskLoitering(posT, radiusT, taskType, 'r--', 'Task loitering');
        
    end

end
