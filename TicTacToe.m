function TicTacToe

%CodeStart-----------------------------------------------------------------
%Preparing MATLAB environment
    close all
    clear all
%Declaring global variable
    playermark=zeros(3);
    commark=zeros(3);
    turn=[];
    winner=[];
%Generating GUI
    ScreenSize=get(0,'ScreenSize');
    mainwindow=figure('Name','Tic-Tac-Toe',...
                      'NumberTitle','Off',...
                      'Menubar','none',...
                      'Resize','off',...
                      'Units','pixels',...
                      'Position',[0.5*(ScreenSize(3)-384),...
                                  0.5*(ScreenSize(4)-400),...
                                  384,400]);
    axes('Parent',mainwindow,...
         'Units','normalized',...
         'Position',[0.1,0.25,0.8,0.7]);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','Start Game',...
              'Units','normalized',...
              'Position',[0.15,0.15,0.2,0.05],...
              'Callback',@startgamefcn);
    uicontrol('Parent',mainwindow,...
              'Style','pushbutton',...
              'String','Close Game',...
              'Units','normalized',...
              'Position',[0.65,0.15,0.2,0.05],...
              'Callback',@closegamefcn);
    instructionbox=uicontrol('Parent',mainwindow,...
                             'Style','text',...
                             'String',['Click Start Game button to',...
                                       ' begin the game...'],...
                             'Units','normalized',...
                             'Position',[0.1,0.05,0.8,0.04]);
%Initiating graphics
    hold on
    drawboard(playermark,commark)
%Declaring LocalFunction
    %Start of drawboard
    function drawboard(playermark,commark)
        %Drawing board background
        axis off
        axis([0.5 3.5 0.5 3.5])
        rectangle('Position',[0.5 0.5 3 3])
        rectangle('Position',[1.5 0.5 1 3])
        rectangle('Position',[0.5 1.5 3 1])
        %Drawing player mark
        %[row,col] = find(___) returns the row and column subscripts of each nonzero element in array X using any of the input arguments in previous syntaxes.

        [row,col]=find(playermark==1);
        if ~isempty(row)
            for i=1:1:numel(row)
                drawcircle(col(i),4-row(i))
            end
        end
        %Drawing com mark
        [row,col]=find(commark==1);
        if ~isempty(row)
            for i=1:1:numel(row)
                drawcross(col(i),4-row(i))
            end
        end
    end
    %End of drawboard
    %Start of drawcircle
    function drawcircle(row,col)
        rectangle('Position',[row-0.3 col-0.3 0.6 0.6],...
                  'Curvature',[1 1],...
                  'LineWidth',5)
    end
	%End of drawcircle
    %Start of drawcross
    function drawcross(row,col)
        line([row-0.3 row+0.3],[col-0.3 col+0.3],...
             'LineWidth',5,...
             'Color',[0 0 0])
        line([row-0.3 row+0.3],[col+0.3 col-0.3],...
             'LineWidth',5,...
             'Color',[0 0 0]);
    end
    %End of drawcross
    %Start of playermove
    function playermark=playermove(playermark,commark)
        endturn=0;
        set(instructionbox,'String',['Your turn, choose your spot and',...
                                     ' press enter...'])
        while endturn==0
            %Prompting player input
            try
               [x,y]=ginput(1);
            catch
                winner='n';
                return
            end
            row=4-ceil(y(1)-0.5);
            col=ceil(x(1)-0.5);
            %Checking player input
            endturn=checkmove(row,col,playermark,commark);
            %Updating board
            if endturn==1
                playermark(row,col)=1;
                drawboard(playermark,commark)
            else
                set(instructionbox,'String',['Cannot choose that spot!',...
                                             ' Choose another spot!'])
            end
        end
    end
    %End of playermove
    %Start of commove
    function commark=commove(playermark,commark)
        endturn=0;
        set(instructionbox,'String','COM turn, please wait...')
        while endturn==0
            %Creating COM input
            [row,col]=comthink(playermark,commark);
            %Checking COM input
            endturn=checkmove(row,col,playermark,commark);
            %Updating board
            if endturn==1
                commark(row,col)=1;
                drawboard(playermark,commark)
            else
                set(instructionbox,'String',['Cannot choose that spot!',...
                                             ' Choose another spot!'])
            end
        end
    end
    %End of commove
    %Start of comthink
    function [row,col]=comthink(playermark,commark)
        score=zeros(3);
        %Basic thinking
        for i=1:3
            for j=1:3
                score(i,j)=sum(commark(i,:))+sum(commark(:,j))-...
                           sum(playermark(i,:))-sum(playermark(:,j));
            end
        end
        score(1,1)=score(1,1)-playermark(2,2)-playermark(3,3)+...
                              commark(2,2)+commark(3,3);
        score(3,3)=score(3,3)-playermark(2,2)-playermark(1,1)+...
                              commark(2,2)+commark(1,1);
        score(3,1)=score(3,1)-playermark(2,2)-playermark(1,3)+...
                              commark(2,2)+commark(1,3);
        score(1,3)=score(1,3)-playermark(2,2)-playermark(3,1)+...
                              commark(2,2)+commark(3,1);
        score(2,2)=score(2,2)-playermark(1,1)-playermark(3,3)+...
                              playermark(1,3)+playermark(3,1)+...
                              commark(1,1)+commark(3,3)+...
                              commark(1,3)+commark(3,1);
        %Offensive thinking
        for i=1:3
            if ((commark(i,1)==1)&&(commark(i,2)==1))
                score(i,3)=Inf;
            end
            if ((commark(i,1)==1)&&(commark(i,3)==1))
                score(i,2)=Inf;
            end
            if ((commark(i,2)==1)&&(commark(i,3)==1))
                score(i,1)=Inf;
            end
            if ((commark(1,i)==1)&&(commark(2,i)==1))
                score(3,i)=Inf;
            end
            if ((commark(1,i)==1)&&(commark(3,i)==1))
                score(2,i)=Inf;
            end
            if ((commark(2,i)==1)&&(commark(3,i)==1))
                score(1,i)=Inf;
            end
        end
        if ((commark(1,1)==1)&&(commark(2,2)==1))
            score(3,3)=Inf;
        end
        if ((commark(1,1)==1)&&(commark(3,3)==1))
            score(2,2)=Inf;
        end
        if ((commark(2,2)==1)&&(commark(3,3)==1))
            score(3,3)=Inf;
        end
        if ((commark(3,1)==1)&&(commark(2,2)==1))
            score(1,3)=Inf;
        end
        if ((commark(1,3)==1)&&(commark(3,1)==1))
            score(2,2)=Inf;
        end
        if ((commark(1,3)==1)&&(commark(2,2)==1))
            score(3,1)=Inf;
        end
        %Defensive thinking
        for i=1:3
            if ((playermark(i,1)==1)&&(playermark(i,2)==1))
                score(i,3)=score(i,3)+100;
            end
            if ((playermark(i,1)==1)&&(playermark(i,3)==1))
                score(i,2)=score(i,2)+100;
            end
            if ((playermark(i,2)==1)&&(playermark(i,3)==1))
                score(i,1)=score(i,1)+100;
            end
            if ((playermark(1,i)==1)&&(playermark(2,i)==1))
                score(3,i)=score(3,i)+100;
            end
            if ((playermark(1,i)==1)&&(playermark(3,i)==1))
                score(2,i)=score(2,i)+100;
            end
            if ((playermark(2,i)==1)&&(playermark(3,i)==1))
                score(1,i)=score(1,i)+100;
            end
        end
        if ((playermark(1,1)==1)&&(playermark(2,2)==1))
            score(3,3)=score(3,3)+100;
        end
        if ((playermark(1,1)==1)&&(playermark(3,3)==1))
            score(2,2)=score(2,2)+100;
        end
        if ((playermark(2,2)==1)&&(playermark(3,3)==1))
            score(1,1)=score(1,1)+100;
        end
        if ((playermark(3,1)==1)&&(playermark(2,2)==1))
            score(1,3)=score(1,3)+100;
        end
        if ((playermark(1,3)==1)&&(playermark(3,1)==1))
            score(2,2)=score(2,2)+100;
        end
        if ((playermark(1,3)==1)&&(playermark(2,2)==1))
            score(3,1)=score(3,1)+100;
        end
        %Avoiding chosen spot
        for i=1:3
            for j=1:3
                if (playermark(i,j)==1)||(commark(i,j)==1)
                    score(i,j)=-Inf;
                end
            end
        end
        [rowtemp,coltemp]=find(score==max(max(score)));
        if numel(rowtemp)==1
            row=rowtemp;
            col=coltemp;
        else
            choice=ceil(rand*numel(rowtemp));
            row=rowtemp(choice);
            col=coltemp(choice);
        end
    end
    %End of comthink
    %Start of checkmove
    function endturn=checkmove(row,col,playermark,commark)
        if (row>3)||(row<1)||(col>3)||(col<1)
            endturn=0;
        else
            if (playermark(row,col)==0)&&(commark(row,col)==0)
                endturn=1;
            else
                endturn=0;
            end
        end
    end
    %End of checkmove
    %Start of checkboard
    function winner=checkboard(playermark,commark)
        if ((playermark(1,1)==1)&&(playermark(1,2)==1)&&...
            (playermark(1,3)==1))||...
           ((playermark(2,1)==1)&&(playermark(2,2)==1)&&...
            (playermark(2,3)==1))||...
           ((playermark(3,1)==1)&&(playermark(3,2)==1)&&...
            (playermark(3,3)==1))||...
           ((playermark(1,1)==1)&&(playermark(2,1)==1)&&...
            (playermark(3,1)==1))||...
           ((playermark(1,2)==1)&&(playermark(2,2)==1)&&...
            (playermark(3,2)==1))||...
           ((playermark(1,3)==1)&&(playermark(2,3)==1)&&...
            (playermark(3,3)==1))||...
           ((playermark(1,1)==1)&&(playermark(2,2)==1)&&...
            (playermark(3,3)==1))||...
           ((playermark(3,1)==1)&&(playermark(2,2)==1)&&...
            (playermark(1,3)==1))
            winner='p';
        elseif ((commark(1,1)==1)&&(commark(1,2)==1)&&...
                (commark(1,3)==1))||...
               ((commark(2,1)==1)&&(commark(2,2)==1)&&...
                (commark(2,3)==1))||...
               ((commark(3,1)==1)&&(commark(3,2)==1)&&...
                (commark(3,3)==1))||...
               ((commark(1,1)==1)&&(commark(2,1)==1)&&...
                (commark(3,1)==1))||...
               ((commark(1,2)==1)&&(commark(2,2)==1)&&...
                (commark(3,2)==1))||...
               ((commark(1,3)==1)&&(commark(2,3)==1)&&...
                (commark(3,3)==1))||...
               ((commark(1,1)==1)&&(commark(2,2)==1)&&...
                (commark(3,3)==1))||...
               ((commark(3,1)==1)&&(commark(2,2)==1)&&...
                (commark(1,3)==1))
            winner='c';
        elseif sum(sum(playermark))+sum(sum(commark))==9
            winner='d';
        else
            winner=[];
        end
    end
    %End of checkboard
%Declaring CallbackFunction
    %Start of startgamefcn
    function startgamefcn(~,~)
        %Resetting mark
        playermark=zeros(3);
        commark=zeros(3);
        winner=[];
        %Resetting board
        cla
        drawboard(playermark,commark)
        %Randomly choose player for first turn
        decision=rand;
        if decision<=0.5
            turn='c';
        elseif decision>0.5
            turn='p';
        end
        %Playing games
        while isempty(winner)
            if strcmpi(turn,'p')
                playermark=playermove(playermark,commark);
                if ~strcmpi(winner,'n')
                    winner=checkboard(playermark,commark);
                end
            elseif strcmpi(turn,'c')
                commark=commove(playermark,commark);
                winner=checkboard(playermark,commark);
            end
            if isempty(winner)
                if strcmpi(turn,'p')
                    turn='c';
                elseif strcmpi(turn,'c')
                    turn='p';
                end
            else
                if strcmpi(winner,'p')
                    set(instructionbox,'String',['Congratulations!',...
                                                 ' You win!!!'])
                elseif strcmpi(winner,'c')
                    set(instructionbox,'String',['You lose!',...
                                                 ' Press Start to retry!'])
                elseif strcmpi(winner,'d')
                    set(instructionbox,'String',['It is a draw.',...
                                                 ' Press Start to retry!'])
                end
            end
        end
    end
    %End of startgamefcn
    %Start of closegamefcn
    function closegamefcn(~,~)
        winner='n';
        clear all
        close 'Tic-Tac-Toe'
    end
    %End of closegamefcn
%CodeEnd-------------------------------------------------------------------

end