function [] = CCDE()
%Olin Shipstead
%3 December 2018
%Final Project:
%Climate Change Data Explorer GUI

clear all
close all
clc

%introduce instance variables into workspace to allow for variables throughout nested functions
%vectors for climate change info
YEAR=[];
TAVG=[];
SLVL=[];
PRCP=[];
TMAX=[];
FIRE=[];
%vectors for polyfit of data
CAp=[];
LAp=[];
RIp=[];
MTp=[];
WAp=[];
%indicates which button was last pressed
whichbutton='';

%figure window
f=figure(1);
    f.Name='Climate Change Data Explorer';
    f.Units='Normalized';
    f.Position=[.4 .15 .55 .7] ;
    
%map of the US
    ax = usamap('conus'); %default map of contiguous US
    ax.Position = [.1 .3 .8 .8];
    %read in states, excluding AL and HI
    states = shaperead('usastatelo', 'UseGeoCoords', true,'Selector',{@(name) ~any(strcmp(name,{'Alaska','Hawaii'})), 'Name'});
    %create states into polygons, assign random color
    faceColors = makesymbolspec('Polygon',{'INDEX', [1 numel(states)], 'FaceColor',polcmap(numel(states))}); 
    %display map with specifications
    geoshow(ax, states, 'DisplayType', 'polygon', 'SymbolSpec', faceColors)
    %remove labels/grids
    framem off; gridm off; mlabel off; plabel off;
    
%CA button
CAbtn=uicontrol('Style','Pushbutton');
    CAbtn.String='California';
    CAbtn.Units='Normalized';
    CAbtn.Position=[.125 .65 .1 .05];
    CAbtn.Callback=@loadplot;
    
%WA button
WAbtn=uicontrol('Style','Pushbutton');
    WAbtn.String='Washington';
    WAbtn.Units='Normalized';
    WAbtn.Position=[.125 .9 .1 .05];
    WAbtn.Callback=@loadplot;
      
%RI button
RIbtn=uicontrol('Style','Pushbutton');
    RIbtn.String='Rhode Island';
    RIbtn.Units='Normalized';
    RIbtn.Position=[.75 .825 .1 .05];
    RIbtn.Callback=@loadplot;
    
%LA button
LAbtn=uicontrol('Style','Pushbutton');
    LAbtn.String='Louisiana';
    LAbtn.Units='Normalized';
    LAbtn.Position=[.55 .5 .1 .05];
    LAbtn.Callback=@loadplot;
    
%MT button
MTbtn=uicontrol('Style','Pushbutton');
    MTbtn.String='Montana';
    MTbtn.Units='Normalized';
    MTbtn.Position=[.34 .94 .1 .05];
    MTbtn.Callback=@loadplot;
    
%plot window
plotwindow=axes();
    plotwindow.Units='Normalized';
    plotwindow.Position=[.525 .1 .45 .375];
    
%initial text for plot window
plottxt=uicontrol('Style','Text');
    plottxt.String='Select a button to view the climate change effects local to that region';
    plottxt.Units='Normalized';
    plottxt.Position=[.575 .25 .35 .075];
    plottxt.FontSize=11;
    
%create data panel
p = uipanel();
    p.BackgroundColor='white';
    p.Position=[.05 .1 .4 .375];
    
%intro text for data panel
ptxt=uicontrol(p,'Style','Text');
    ptxt.String='Climate change is changing the natural world around us at an alarming rate, from increasing temperatures to rising sea levels to wildfires';
    ptxt.Units='Normalized';
    ptxt.Position=[.1 .25 .8 .5];
    ptxt.FontSize=11;
    
%create slider now and make visible later
sld = uicontrol(p,'Style', 'slider');
        sld.Units='Normalized';
        sld.Position=[.1 .23 .8 .08];
        %for data extrapolation from 2020 to 2100
        sld.Min=2020;
        sld.Max=2100;
        sld.Value=2020;
        %step is 5 years
        sld.SliderStep=[1/16 1];
        sld.Callback=@grab_slider;
        sld.Visible='off';
        
%create slider text
sldtxt=uicontrol(p,'Style','text','Units','Normalized','FontSize',10,'Position', [.1 .15 .8 .1]);
    sldtxt.BackgroundColor='white';
    sldtxt.String='2020                                        2100';
    sldtxt.Visible='off';
    
%create texts to display extrapolation data
futuretxt=uicontrol(p,'Style','text','Units','Normalized','FontSize',10,'Position', [.2 .05 .6 .1]);
    futuretxt.BackgroundColor='white';           
    futuretxt.Visible='off';
    
function [] = loadplot(source,event)
    %clear plot area
    plottxt.Visible='off';
    ptxt.Visible='off';
    %clear future text
    futuretxt.String='';
    
    cla(plotwindow)
    
    %if CA button is pushed
    if strcmp(source.String,'California')
        %update whichbutton
        whichbutton='CA';
        
        %plot CA temp data
        load('CA_temp.mat')
        plot(YEAR,TAVG,'.','LineWidth',3)
        xlim([1940 2020])
        xlabel('time (yr)');
        ylabel(['average temp (' char(176) 'F)'])
        
        %plot linear trendline
        CAp=polyfit(YEAR,TAVG,1);
        YEARlin=1940:2020;
        TAVGlin=polyval(CAp,YEARlin);
        hold on
        plot(YEARlin,TAVGlin,'r-')
        legend('Observations','Trendline','Location','northwest');
        hold off
           
        %update text panel
        ptxt.String=['In Los Angeles, CA, average yearly temperatures are increasing approximately 0.04' char(176) 'F each year. That equates to a 3.34' char (176) 'F increase since 1934. Adjust the slider to see what temperatures could be in the future based on the trendline shown.']; 
        ptxt.FontSize=10;
        ptxt.Position=[.05 .35 .9 .6];
        ptxt.Visible='on';
        
        sld.Visible='on';
        sldtxt.Visible='on';
        
        futuretxt.Visible='on';
   
    %if LA button is pushed
    elseif strcmp(source.String,'Louisiana')
        %update whichbutton
        whichbutton='LA';
        
        %plot CA temp data
        load('LA_sealevel.mat')
        plot(YEAR,SLVL,'.','LineWidth',3)
        xlim([1945 2025])
        xlabel('time (yr)');
        ylabel('mean sea level (m)')
        
        %plot linear trendline
        LAp=polyfit(YEAR,SLVL,1);
        YEARlin=1945:2025;
        SLVLlin=polyval(LAp,YEARlin);
        hold on
        plot(YEARlin,SLVLlin,'r-')
        legend('Observations','Trendline','Location','northwest');
        hold off
        
        %update text panel
        ptxt.String='In Grand Isle, Lousiana, the sea level has been rising about 9 mm per year, due in part to the thermal expansion of water. That amounts to 64 cm of sea level rise since 1947. Adjust the slider to see what sea levels could be like in the future based on the trendline shown.'; 
        ptxt.FontSize=10;
        ptxt.Position=[.05 .35 .9 .6];
        ptxt.Visible='on';
        
        sld.Visible='on';
        sldtxt.Visible='on';
        
        futuretxt.Visible='on';
   
    %if RI button is pushed
    elseif strcmp(source.String,'Rhode Island')
        %update whichbutton
        whichbutton='RI';
        
        %plot CA temp data
        load('RI_precip.mat')
        plot(YEAR,PRCP,'.','LineWidth',3)
        xlim([1945 2020])
        xlabel('time (yr)');
        ylabel('precipitation (in)')
        
        %plot linear trendline
        RIp=polyfit(YEAR,PRCP,1);
        YEARlin=1945:2020;
        PRCPlin=polyval(RIp,YEARlin);
        hold on
        plot(YEARlin,PRCPlin,'r-')
        legend('Observations','Trendline','Location','northwest');
        hold off
        
        %update text panel
        ptxt.String='In Providence, Rhode Island, the precipitation has been rising about 0.06 inches per year due to shifting climatic conditions. That amounts to a 4.2 inch increase in precipitation since 1948. Adjust the slider to see what precipitation could be like in the future.'; 
        ptxt.FontSize=10;
        ptxt.Position=[.05 .35 .9 .6];
        ptxt.Visible='on';
        
        sld.Visible='on';
        sldtxt.Visible='on';
        
        futuretxt.Visible='on';
   
    %if MT button is pushed
    elseif strcmp(source.String,'Montana')
        %update whichbutton
        whichbutton='MT';
        
        %plot MT temp data
        load('MT_tmax.mat')
        plot(YEAR,TMAX,'.','LineWidth',3)
        xlim([1915 2025])
        xlabel('time (yr)');
        ylabel(['maximum temp (' char(176) 'F)'])
        
        %plot linear trendline
        MTp=polyfit(YEAR,TMAX,1);
        YEARlin=1915:2025;
        TMAXlin=polyval(MTp,YEARlin);
        hold on
        plot(YEARlin,TMAXlin,'r-')
        legend('Observations','Trendline','Location','northwest');
        hold off
       
        %update text panel
        ptxt.String=['In Kalispell, Montana, the maximum temperature has been rising about 0.03' char(176) 'F per year. That amounts to a 2.97' char(176) 'F increase since 1919. Adjust the slider to see what temperature could be like in the future based on the trendline shown.']; 
        ptxt.FontSize=10;
        ptxt.Position=[.05 .35 .9 .6];
        ptxt.Visible='on';
        
        sld.Visible='on';
        sldtxt.Visible='on';
        
        futuretxt.Visible='on';
   
    %if WA button is pushed
    elseif strcmp(source.String,'Washington')
        %update whichbutton
        whichbutton='WA';
        
        %plot WA wildfires data
        load('WA_wfires.mat');
        bar(YEAR,FIRE);
        xlabel('time (yr)');
        ylabel('wildfire frequency');
        
        %plot linear trendline
        WAp=polyfit(YEAR,FIRE,1);
        YEARlin=1995:2020;
        FIRElin=polyval(WAp,YEARlin);
        hold on
        plot(YEARlin,FIRElin,'r-')
        legend('Observations','Trendline','Location','northwest');
        hold off
    
       %update text panel
        ptxt.String='In Washington state, the frequency of wildfires has been increasing by 1.33 wildfires per year due to exacerbated drought conditions. Adjust the slider to see what the frequency of wildfires could be like in the future based on the trendline shown.'; 
        ptxt.FontSize=10;
        ptxt.Position=[.05 .35 .9 .6];
        ptxt.Visible='on';
        
        sld.Visible='on';
        sldtxt.Visible='on';
        
        futuretxt.Visible='on';
        
    end
end

%to update extrapolation text below slider
function [] = grab_slider(source, event)
    %grab year from slider
    year=round(source.Value,0);
    %apply polyfit based on which button was last pushed and year from
    %slider
    if strcmp(whichbutton,'CA')
        value=polyval(CAp,year);
        futuretxt.String=['In ' num2str(year) ': ' num2str(round(value,1)) char(176) 'F'];
    elseif strcmp(whichbutton,'LA')
        value=polyval(LAp,year);
        futuretxt.String=['In ' num2str(year) ': ' num2str(round(value,3)) ' m'];
    elseif strcmp(whichbutton,'MT')
        value=polyval(MTp,year);
        futuretxt.String=['In ' num2str(year) ': ' num2str(round(value,1)) char(176) 'F'];
    elseif strcmp(whichbutton,'RI')
        value=polyval(RIp,year);
        futuretxt.String=['In ' num2str(year) ': ' num2str(round(value,1)) ' in'];
    else
        value=polyval(WAp,year);
        futuretxt.String=['In ' num2str(year) ': ' num2str(round(value,0)) ' wildfires'];
    end
end


end