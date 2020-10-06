% Adds USARSim Java Library folder to Matlab path list
function addUSARJavaPath()
    p = javaclasspath;
    for i=1:length(p)
        c = p(i);
        if strcmp(c{1}, 'USARSimJava')
            return;
        end
    end
    javaaddpath('USARSim\USARSimJava');