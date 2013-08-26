function output = histogram(input)
    wip = zeros(1, 256);
    [length, width] = size(input);
    for x = 1:length
        for y = 1:width
            wip(input(x,y)+1) = wip(input(x,y)+1) + 1;
        end
    end
    output = wip;