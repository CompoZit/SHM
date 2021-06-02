function [array] = Bar_prop(array,SpltStr,lgd,lgdname) 

%{
- To plot bar graphs with specific properties
%}
if iscell(array)
    array = cell2mat(array);
end
figure()
width =0.3;
bar(array,width);
legend(lgdname)
title(strcat(SpltStr{1,1:2}))
set(gca,'XTickLabels',lgd)
set(gca, 'XTick', linspace(1,length(lgd),length(lgd)), 'XTickLabels', lgd)
xtickangle(45)

end