function thumbnail = lastweekStats(D, numberofdays)
%
% lastweekStats(D, numberofdays)
%
% Plots a graph showing the number of objects annotated in the last days

% Create list of dates, image index, and object names
labelingdate = [];
p = 0;
for n = 1:length(Dt)
    if isfield(Dt(n).annotation, 'object')
        if isfield(Dt(n).annotation.object(1), 'date')
        for m = 1:length(Dt(n).annotation.object)
                d = Dt(n).annotation.object(m).date;
                if length(d)>0
                    p = p + 1;
                    labelingdate{p} = d(1:11);
                end
            end
        end
    end
end
Labelingdate = datenum(labelingdate(1:p));

% last week
currentdate = datenum(date);
week = [];
for i = 1:numberofdays
    week(i) = sum(Labelingdate == (currentdate-i+1));
end

figure
bar(week)

thumbnail = [];
