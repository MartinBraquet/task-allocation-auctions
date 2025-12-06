function [ winners_matrix ] = WinnerVectorToMatrix(N, M, winners)

    winners_matrix = zeros(N, M);
    for i = 1:N
        if winners(i) > 0
            winners_matrix(i,winners(i)) = 1;
        end
    end

end

