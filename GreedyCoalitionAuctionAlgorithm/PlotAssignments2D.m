
% Plots CBBA outputs
%---------------------------------------------------------------------%

function fig = PlotAssignments2D(WORLD, CBBA_Assignments, agents, tasks, figureID)

%---------------------------------------------------------------------%
% Set plotting parameters

set(0, 'DefaultAxesFontSize', 12)
set(0, 'DefaultTextFontSize', 10, 'DefaultTextFontWeight','demi')
set(0,'DefaultAxesFontName','arial')
set(0,'DefaultTextFontName','arial')
set(0,'DefaultLineLineWidth',2); % < == very important
set(0,'DefaultlineMarkerSize',10)

%---------------------------------------------------------------------%
% Plot X and Y agent and task positions vs. time

offset = (WORLD.XMAX - WORLD.XMIN)/100;
fig    = figure(figureID);
Cmap   = colormap('lines');

% Plot tasks
for m=1:length(tasks)
    plot(tasks(m).x + [0 0], tasks(m).y + [0 0],'x:','color',Cmap(tasks(m).type,:),'LineWidth',3);
    hold on;
    text(tasks(m).x+offset, tasks(m).y+offset, tasks(m).start, ['T' num2str(m)]);
end
% Plot agents
for n=1:length(agents)
    plot(agents(n).x, agents(n).y,'o','color',Cmap(agents(n).type,:));
    text(agents(n).x+offset, agents(n).y+offset, 0.1, ['A' num2str(n)]);
    % Check if path has something in it
    if( CBBA_Assignments(n).path(1) > -1 )
        taskPrev = lookupTask(tasks, CBBA_Assignments(n).path(1));
        X = [agents(n).x, taskPrev.x];
        Y = [agents(n).y, taskPrev.y];
        T = [0, CBBA_Assignments(n).times(1)];
        plot(X,Y,'-','color',Cmap(agents(n).type,:));
        plot(X(end)+[0 0], Y(end)+[0 0], '-^','color',Cmap(agents(n).type,:));
        % Add time and path to agents(n)
        agents(n).time = round(CBBA_Assignments(n).times(1)/100);
        agents(n).path = [taskPrev.x, taskPrev.y, agents(n).z, taskPrev.duration/100, taskPrev.id];
        
        for m = 2:length(CBBA_Assignments(n).path);
            if( CBBA_Assignments(n).path(m) > -1 )
                taskNext = lookupTask(tasks, CBBA_Assignments(n).path(m));
                X = [taskPrev.x, taskNext.x];
                Y = [taskPrev.y, taskNext.y];
                T = [CBBA_Assignments(n).times(m-1)+taskPrev.duration, CBBA_Assignments(n).times(m)];
                plot(X,Y,'-^','color',Cmap(agents(n).type,:));
                plot(X(end)+[0 0], Y(end)+[0 0], '-^','color',Cmap(agents(n).type,:));
                % Add path to agents(n)
                agents(n).path = [agents(n).path; taskNext.x, taskNext.y, agents(n).z, taskNext.duration/100, taskNext.id];
                
                taskPrev = taskNext;
            else
                break;
            end
        end 
    end
end
hold off;
title(['Agent Paths with Time Windows'])
xlabel('X');
ylabel('Y');
grid on

return

function task = lookupTask(tasks, taskID)

for m=1:length(tasks),
    if(tasks(m).id == taskID)
        task = tasks(m);
        return;
    end
end

task = [];
disp(['Task with index=' num2str(taskID) ' not found'])

return

    