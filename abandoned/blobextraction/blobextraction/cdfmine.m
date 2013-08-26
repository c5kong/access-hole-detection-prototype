function output = cdfmine(input);
    [length, width] = size(input);
    histo = histogram(input);
    histo = histo/(length * width);
    wip = zeros(1,256);
    wip(1) = histo(1);
    for x = 2:256
        wip(x) = wip(x-1) + histo(x);
    end
    output = wip;