function [xlim1] = Plot_prop(sav_folder,Fr,Ylabel) 

%{
- To plot the admittance, the resistance and other graphs with specific properties
%}
yticks = get(gca,'YTick');
set(gca,'YTickLabel',yticks);
xticks = get(gca,'XTick');
set(gca,'XTickLabel',xticks);
xlabel ('Frequency [Hz]','FontSize', 20)
ylabel (Ylabel,'FontSize', 20)
xlim1=Fr(end,1);
xlim ([xlim1 Fr(1,1)])
title (erase(sav_folder,'_'))
legend show
legend('Location','Best')
hold on

end

