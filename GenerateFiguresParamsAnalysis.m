close all; clear all;

simuName = 'Variation of parameters';
lineWidth = 3;

AllParamsToAnalyze = {'RangeLimitation', 'RewardSuccessProbability', 'NumberAgentsTasks', 'TimeRatioLoiteringTasks'};

%%

paramToAnalyze = AllParamsToAnalyze{1};
simuNumber = 1;
load(sprintf('mat/%s/%s/simu_%d/ratioRangeMapWidth-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/totalUtilityAllocation-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/SimuParamsCell.mat', simuName, paramToAnalyze, simuNumber));

figure;
plot(ratioRangeMapWidth, totalUtilityAllocation, 'LineWidth', lineWidth);
ylim([0 max(totalUtilityAllocation)*1.1]);
xlabel('Communication range');
ylabel('Utility');
matlab2tikz(sprintf('mat/%s/%s/simu_%d/RangeLimitationUtility.tex', simuName, paramToAnalyze, simuNumber));

%%

paramToAnalyze = AllParamsToAnalyze{2};
simuNumber = 1;

load(sprintf('mat/%s/%s/simu_%d/nomReward-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/nomProbAT-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/totalUtilityAllocation-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/SimuParamsCell.mat', simuName, paramToAnalyze, simuNumber));

figure;
[mechNomReward, meshNomProbAT] = meshgrid(nomReward, nomProbAT);
surf(mechNomReward, meshNomProbAT, totalUtilityAllocation);
xlabel('Nominal reward');
ylabel('Task success probability');
zlabel('Utility');
matlab2tikz(sprintf('mat/%s/%s/simu_%d/RewardSuccessProbabilityUtility.tex', simuName, paramToAnalyze, simuNumber));

%%

paramToAnalyze = AllParamsToAnalyze{3};
simuNumber = 3;

load(sprintf('mat/%s/%s/simu_%d/nAVect-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/nTVect-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/totalUtilityAllocation-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/totalComputationTime-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/SimuParamsCell.mat', simuName, paramToAnalyze, simuNumber));

[mechnAVect, meshnTVect] = meshgrid(nAVect, nTVect);

figure;
surf(mechnAVect, meshnTVect, totalUtilityAllocation);
xlabel('Number of agents');
ylabel('Number of tasks');
zlabel('Utility');
matlab2tikz(sprintf('mat/%s/%s/simu_%d/nTnAUtility.tex', simuName, paramToAnalyze, simuNumber));

figure;
surf(mechnAVect, meshnTVect, totalComputationTime);
xlabel('Number of agents');
ylabel('Number of tasks');
zlabel('Computation time');
matlab2tikz(sprintf('mat/%s/%s/simu_%d/nTnAComputationTime.tex', simuName, paramToAnalyze, simuNumber));

%%

paramToAnalyze = AllParamsToAnalyze{4};
simuNumber = 1;

load(sprintf('mat/%s/%s/simu_%d/ntLoiterVect-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/totalUtilityAllocation-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/totalComputationTime-%d.mat', simuName, paramToAnalyze, simuNumber));
load(sprintf('mat/%s/%s/simu_%d/SimuParamsCell.mat', simuName, paramToAnalyze, simuNumber));

% figure;
% plot(ntLoiterVect, totalUtilityAllocation, 'LineWidth', lineWidth);
% ylim([0 max(totalUtilityAllocation)*1.1]);
% xlabel('Ratio of loitering tasks');
% ylabel('Utility');
% matlab2tikz(sprintf('mat/%s/%s/simu_%d/ntLoiterUtility.tex', simuName, paramToAnalyze, simuNumber));

figure;
plot(ntLoiterVect, totalComputationTime, 'LineWidth', lineWidth);
ylim([0 max(totalComputationTime)*1.1]);
xlabel('Ratio of loitering tasks');
ylabel('Computation time');
matlab2tikz(sprintf('mat/%s/%s/simu_%d/ntLoiterComputationTime.tex', simuName, paramToAnalyze, simuNumber));

% figure;
% yyaxis left
% plot(ntLoiterVect, totalUtilityAllocation, 'LineWidth', lineWidth); hold on;
% ylim([0 max(totalUtilityAllocation)*1.1]);
% xlabel('Ratio of loitering tasks');
% ylabel('Utility');
% yyaxis right
% plot(ntLoiterVect, totalComputationTime, 'LineWidth', lineWidth);
% %grid;
% ylabel('Computation time');
% matlab2tikz(sprintf('mat/%s/%s/simu_%d/ntLoiterUtilityComputationTime.tex', simuName, paramToAnalyze, simuNumber));