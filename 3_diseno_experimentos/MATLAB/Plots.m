
for i=1:15 
    %Meshgrid Size effect - Sample size
    [X,Y] = meshgrid(0:0.05:0.65,200:50:1000);
    %Read statistical power matrix
    M = csvread(['pwr_iv2_',num2str(i) ,'.csv']);
    %Interpolation grid
    [yy, xx] = meshgrid(0:0.05:0.65,200:50:1000);

    %Plot
    figure('units','normalized','outerposition',[0 0 1 1])
        %3D plot
    subplot(1,2,1);
    surfc(xx,yy,interp2(X,Y,M,yy,xx))
    colorbar('southoutside')
    xlabel('Sample size')
    ylabel('ATT size')
    zlabel('Statistical power')
        %Level curve plot
    subplot(1,2,2);
    plot(200:50:1000, M(:,[2,5,7,11,12,14]),'LineWidth' , 2)
    xlabel('Sample size')
    ylabel('Statistical power')
    lgd=legend(num2str(X(1,2)),num2str(X(1,5)),num2str(X(1,7)),num2str(X(1,11)),...
        num2str(X(1,12)),num2str(X(1,14)),'Location','southoutside','Orientation', 'horizontal' );
    title(lgd,'ATT size')
    grid on
    
    print(gcf, '-dtiff', ['pwr_iv2_',num2str(i) ,'.png'], '-r100')
end


