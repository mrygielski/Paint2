
program paint2;

uses help2, help13h, helpkeys, helprys, helpmous, regi;

procedure pole(kolor : byte);
var
   x, y : integer;
procedure box(x, y, a : integer);
begin
     rectangle13h(x,y,x+a,y+a,7);
end;
begin
     bar13h(5,15,184,195,0);
     for x:= 1 to 60 do
     for y:= 1 to 60 do
     begin
          box(1+x*3,12+y*3,3);
     end;
end;

procedure pole2;
var
   x, y : integer;
procedure box(x, y, a : integer);
begin
     bar13h(1+x,1+y,x-1+a,y-1+a,0);
end;
begin
     for x:= 1 to 60 do
     for y:= 1 to 60 do
     begin
          box(1+x*3,12+y*3,3);
     end;
end;

procedure button(x, y, tx : integer; kolor : byte; tekst : string);
begin
     bar13h(x,y,x+50,y+9,26);
     outtextxy13h(x+tx,y+1,1,1,kolor,tekst,false);
end;

procedure kolory;
var
   x, y : integer;
procedure box(x, y, a, kolor : integer);
begin
     bar13h(x,y,x+a,y+a,kolor);
end;
begin
     for x:= 1 to 1 do
     for y:= 1 to 38 do
     begin
          box(185+x*4,39+y*4,4,y);
          box(190+x*4,39+y*4,4,y+38);
          box(195+x*4,39+y*4,4,y+76);
          box(200+x*4,39+y*4,4,y+114);
          box(205+x*4,39+y*4,4,y+152);
          box(210+x*4,39+y*4,4,y+190);
     end;
     for x:= 1 to 1 do
     for y:= 1 to 27 do
     begin
          box(215+x*4,39+y*4,4,y+228);
     end;
end;

var
   mx, my : integer;
   ax, ay : integer;
   x, y, k : integer;
   kolor, kol : word;
   kx, ky : integer;
   cx, cy : integer;
   pplik, pedycja, pfiltry, ppomoc : pointer; {MENU}
   pbackgr : pointer;
   screen : pointer;
   timer : stoper;
   nameopen, namesave : string;
   ex : byte;
   qx : byte;
   sy : integer;
   kopiuj : boolean;
   menu, menuo : boolean;
   {ROZMAZANIE}
   ileblur : byte;
   shadow : boolean;
   {KOLORY}
   ilecolor : word;
   {KOLORY RGB}
   ilergb, r, g, b : word;
   {KOLORY XOR}
   ilexor : word;
   {WIART}
   ilewiatr : word;
   kierunek : kierunki;

procedure kolory2;
var
   x, y : integer;
procedure box(x2, y2, a, kolor : integer);
begin
     if mousein(x,y,x2,y2,x2+a,y2+2) or (k=1) then begin kolor:=y; end;
end;
begin
     for x:= 1 to 1 do
     for y:= 1 to 38 do
     begin
          box(185+x*4,39+y*4,4,y);
{          box(190+x*4,39+y*4,4,y+38);
          box(195+x*4,39+y*4,4,y+76);
          box(200+x*4,39+y*4,4,y+114);
          box(205+x*4,39+y*4,4,y+152);
          box(210+x*4,39+y*4,4,y+190);}
     end;
     {
     for x:= 1 to 1 do
     for y:= 1 to 27 do
     begin
          box(215+x*4,39+y*4,4,y+228);
     end;}
end;

procedure kolorypola;
procedure box(x1, y1, a, kolor1 : integer);
begin
     if mousein(x,y,x1,y1,x1+a,y1+a) then kolor:=kolor1;
end;
var
   x, y : integer;
begin
     for x:= 1 to 1 do
     for y:= 1 to 38 do
     begin
          box(185+x,39+y*4,4,y);
          box(190+x,39+y*4,4,y);
{          box(190+x*4,39+y*4,4,y+38);
          box(195+x*4,39+y*4,4,y+76);
          box(200+x*4,39+y*4,4,y+114);
          box(205+x*4,39+y*4,4,y+152);
          box(210+x*4,39+y*4,4,y+190);}
     end;
{     for x:= 1 to 1 do
     for y:= 1 to 27 do
     begin
          box(215+x*4,39+y*4,4,y+228);
     end;}
end;

procedure getpointer;
begin
     getmem(screen,64000);
     getmem(pplik,5000);
     getmem(pedycja,5000);
     getmem(pfiltry,5000);
     getmem(ppomoc,5000);
     getmem(pbackgr,10000);
end;

procedure freepointer;
begin
     freemem(screen,64000);
     freemem(pplik,5000);
     freemem(pedycja,5000);
     freemem(pfiltry,5000);
     freemem(ppomoc,5000);
     freemem(pbackgr,10000);
end;

procedure wyjscie;
var
   y : integer;
begin
     for y:= 17 to 31 do
     begin
          line13h(55,5*y+1-25,255,5*y+1-25,y);
          line13h(55,5*y+2-25,255,5*y+2-25,y);
          line13h(55,5*y+3-25,255,5*y+3-25,y);
          line13h(55,5*y+4-25,255,5*y+4-25,y);
          line13h(55,5*y+5-25,255,5*y+5-25,y);
     end;
     rysunekglowny(53,41);
     outtextxy13h(130,71,1,1,28,'PAINT 2 vBETA',false);
     outtextxy13h(175,95,1,1,26,'by',false);
     outtextxy13h(120,121,1,1,24,'MICHAL RYGIELSKI',false);
     outtextxy13h(120,121,1,1,24,'     -',false);
end;

type
    tablica = array [1..60, 1..60] of byte;

    zapis =
            record
                  naglowek : string[3];
                  rysunek : tablica;
            end;

var
   f : file of zapis;
   zap : zapis;
   tab : tablica;

procedure loadmrp(xx, yy : integer; plik : string);

begin
     assign(f,plik);
     reset(f);
     read(f,zap);
     close(f);
     tab:=zap.rysunek;
     for x:= 1 to 60 do
     for y:= 1 to 60 do
     begin
          if tab[x,y] <> 0 then putpixel13h(x+xx,y+yy,tab[x,y]);
     end;
end;

procedure loadmrp2(xx, yy : integer; plik : string);

begin
     assign(f,plik);
      reset(f);
     read(f,zap);
     close(f);
     tab:=zap.rysunek;
     for x:= 1 to 60 do
     for y:= 1 to 60 do
     begin
          if tab[x,y] <> 0 then
          begin
               putpixel13h(x*3+xx,y*3+yy,tab[x,y]);
               putpixel13h(1+x*3+xx,y*3+yy,tab[x,y]);
               putpixel13h(x*3+xx,1+y*3+yy,tab[x,y]);
               putpixel13h(1+x*3+xx,1+y*3+yy,tab[x,y]);
          end;
     end;
end;

const
     {PLIKI TYMCZASOWE}
     mrpfile1 = 'temp\0000001.mrp'; {PLIK DO ZAPISU}
     mrpfile2 = 'temp\0000002.mrp'; {PLIK DO ZAPISU}

procedure deletemrp;
var
   f : text;
begin
     assign(f,mrpfile1);
     rewrite(f);
     close(f);
     assign(f,mrpfile2);
     rewrite(f);
     close(f);
end;

procedure kolorbar;
begin
      if mousein(x,y,5,15,61*3,65*3) then
      begin
           mx:=(x-2) div 3;
           my:=(y-12) div 3;
           outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
      end else outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
      if mousein(x,y,228,50,235,59) and (k=1) then
      begin
           mhide;
           outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
           outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
           outtextxy13h(240,51,1,1,29,'KOL='+NumStr(Kolor),false);
           czekaj(100);
           rectangle13h(kx,1+ky,kx+4,1+ky+3,kolor);
           ky:=ky-4;
           if (ky=39) and (kx=189) then
           begin
                ky:=ky+4;
           end;
           if ky<43 then
           begin
                ky:=191;
                kx:=kx-5;
           end;
           rectangle13h(kx,1+ky,kx+4,1+ky+3,15);
           kolor:=kolor-1;
           if kolor<1 then
           begin
                mhide;
                kolor:=kolor+1;
                bar13h(240,50,300,59,26);
                mshow;
                outtextxy13h(240,51,1,1,29,'KOL='+NumStr(Kolor),false);
           end;
           bar13h(240,50,300,59,26);
           outtextxy13h(240,51,1,1,29,'KOL='+NumStr(Kolor),false);
           mshow;
      end;
      if mousein(x,y,305,50,313,59) and (k=1) then
      begin
           mhide;
           outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
           outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
           outtextxy13h(240,51,1,1,29,'KOL='+NumStr(Kolor),false);
           czekaj(100);
           rectangle13h(kx,1+ky,kx+4,1+ky+3,kolor);
           kolor:=kolor+1;
           ky:=ky+4;
           if ky>191 then
           begin
                ky:=43;
                kx:=kx+5;
           end;
           if (ky=151) and (kx=219) then
           begin
                ky:=ky-4;
           end;
           rectangle13h(kx,1+ky,kx+4,1+ky+3,15);
           if kolor>255 then
           begin
                mhide;
                kolor:=kolor-1;
                bar13h(240,50,300,59,26);
                mshow;
                outtextxy13h(240,51,1,1,29,'KOL='+NumStr(Kolor),false);
           end;
           bar13h(240,50,300,59,26);
           outtextxy13h(240,51,1,1,29,'KOL='+NumStr(Kolor),false);
           mshow;
      end;
end;


procedure edycja;
begin
     if menu=true then
     begin
      {EDYCJA}
      if mousein(x,y,53,1,103,9) and (k=1) then
      begin
           mhide;
           getimage13h(pedycja,53,11,101,29);
           button(53,1,1,24,'EDYCJA');
           bar13h(53,11,101,29,25);
           outtextxy13h(53,12,1,1,15,'KOPIUJ',false);
           outtextxy13h(53,21,1,1,15,'WKLEJ',false);
           mshow;
           czekaj(300);
           outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
           ex:=0;
           qx:=0;
           repeat
                 getmousepos(x,y,k);
                 x:=x div 2;
                 outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
                 if (ax<>x) or (ay<>y) then
                 begin
                      mhide;
                      ax:=x;
                      ay:=y;
                      bar13h(189,29,315,38,26);
                      mshow;
                 end;
                 if mousein(x,y,53,12,101,20) and (k=1) then
                 begin
                      ex:=1;
                      qx:=1;
                      kopiuj:=true;
                 end;
                 if mousein(x,y,53,21,101,29) and (k=1) then
                 begin
                      ex:=1;
                      qx:=2;
                 end;
           until (k=2) or (ex=1);
           mhide;
           button(53,1,1,29,'EDYCJA');
           putimage13h(pedycja,53,11);
           bar13h(189,15,315,24,26);
           if (qx=1) then
           begin
                savemrpscreen60x60(239,69,mrpfile1);
           end;
           if (qx=2) then
           begin
                if kopiuj=true then
                begin
{                     bar13h(240,70,299,129,0);}
{                     pole2;}
                     loadmrp2(2,13,mrpfile1);
                     loadmrp(239,69,mrpfile1);
                end;
                if kopiuj=false then
                begin
                     getimage13h(pbackgr,70,80,260,120);
                     bar13h(70,80,260,120,24);
                     outtextxy13h(75,85,1,1,15,'BLAD:',false);
                     outtextxy13h(75,85,1,1,15,' -',false);
                     outtextxy13h(75,95,1,1,12,'NAJPIERW SKOPIUJ EKRAN',false);
                     button(135,105,9,15,' OK');
                     outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
                     qx:=0;
                     mshow;
                     repeat
                           getmousepos(x,y,k);
                           x:=x div 2;
                           outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
                           if (ax<>x) or (ay<>y) then
                           begin
                                mhide;
                                ax:=x;
                                ay:=y;
                                bar13h(189,29,315,38,26);
                                mshow;
                           end;
                           if mousein(x,y,135,105,185,114) and (k=1) then
                           begin
                                qx:=1;
                           end;
                     until (qx=1);
                     mhide;
                     putimage13h(pbackgr,70,80);
                     mshow;
                end;
           end;
           mshow;
           end;
     end;
     if menu=false then
     begin
     end;
end;

procedure filtry;
begin
      {FILTRY}
      if menu=true then
      begin
      if mousein(x,y,105,1,155,9) and (k=1) then
      begin
           mhide;
           button(105,1,1,24,'FILTRY');
           getimage13h(screen,0,0,319,199);
           getimage13h(pfiltry,105,11,105,50);
           bar13h(105,11,185,60,25);
           outtextxy13h(105,12,1,1,15,'ROZMAZANIE',false);
           outtextxy13h(105,20,1,1,15,'KOLORY',false);
           outtextxy13h(105,28,1,1,15,'KOLORY RGB',false);
           outtextxy13h(105,36,1,1,15,'KOLORY XOR',false);
           outtextxy13h(105,44,1,1,15,'WIATR',false);
           outtextxy13h(105,52,1,1,15,'PIKSELOZA',false);
           mshow;
           czekaj(300);
           outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
           qx:=0;
           repeat
                 getmousepos(x,y,k);
                 x:=x div 2;
                 outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
                 if (ax<>x) or (ay<>y) then
                 begin
                      mhide;
                      ax:=x;
                      ay:=y;
                      bar13h(189,29,315,38,26);
                      mshow;
                 end;
                 {ROZMAZANIE}
                 if mousein(x,y,105,12,185,18) and (k=1) then
                 begin
                      mhide;
                      savemrpscreen60x60(239,69,mrpfile2);
                      getimage13h(pbackgr,50,65,231,71);
                      bar13h(50,65,280,135,0);
                      bar13h(56,71,115,130,0);
                      loadmrp(55,70,mrpfile2);
                      bar13h(120,70,128,79,26);
                      outtextxy13h(120,71,1,1,29,'-',false);
                      bar13h(133,70,150,79,26);
                      ileblur:=1;
                      outtextxy13h(134,71,1,1,29,numstr(ileblur),false);
                      bar13h(155,70,164,79,26);
                      outtextxy13h(155,71,1,1,29,'+',false);
                      bar13h(120,84,164,93,26);
                      outtextxy13h(122,85,1,1,15,' RUN',false);
                      bar13h(120,98,164,107,26);
                      outtextxy13h(122,99,1,1,15,'BEGIN',false);
                      outtextxy13h(125,113,1,1,15,'CIEN',false);
                      outtextxy13h(126,112,1,1,15,'   ''',false);
                      bar13h(137,124,145,130,15);
                      rectangle13h(137,124,145,130,26);
                      mshow;
                      shadow:=false;
                      button(195,70,1,15,'  OK');
                      button(195,84,1,15,'ANULUJ');
                      ex:=0;
                      repeat
                            getmousepos(x,y,k);
                            x:=x div 2;
                            {-}
                            if mousein(x,y,120,70,128,79) and (k=1) then
                            begin
                                 mhide;
                                 ileblur:=ileblur-1;
                                 czekaj(100);
                                 if ileblur=0 then
                                 begin
                                      mhide;
                                      ileblur:=ileblur+1;
                                      mshow;
                                 end;
                                 bar13h(133,70,150,79,26);
                                 outtextxy13h(134,71,1,1,29,numstr(ileblur),false);
                                 mshow;
                            end;
                            {+}
                            if mousein(x,y,155,70,164,79) and (k=1) then
                            begin
                                 mhide;
                                 ileblur:=ileblur+1;
                                 czekaj(100);
                                 if ileblur=21 then
                                 begin
                                      mhide;
                                      ileblur:=ileblur-1;
                                      mshow;
                                 end;
                                 bar13h(133,70,150,79,26);
                                 outtextxy13h(134,71,1,1,29,numstr(ileblur),false);
                                 mshow;
                            end;
                            {RUN}
                            if mousein(x,y,120,84,164,93) and (k=1) then
                            begin
                                 mhide;
                                 czekaj(200);
                                 bar13h(53,68,118,133,0);
                                 loadmrp(55,70,mrpfile2);
                                 blur13h(56,71,116,130,ileblur,shadow);
                                 mshow;
                            end;
                            {BEGIN}
                            if mousein(x,y,120,98,164,107) and (k=1) then
                            begin
                                 mhide;
                                 bar13h(53,68,118,133,0);
                                 loadmrp(55,70,mrpfile2);
                                 mshow;
                            end;
                            {CIEN}
                            if mousein(x,y,37,124,145,130) and (k=1) then
                            begin
                                 mhide;
                                 czekaj(100);
                                 if shadow=false then
                                 begin
                                      mhide;
                                      shadow:=true;
                                      bar13h(139,126,143,128,0);
                                      czekaj(100);
                                      mshow;
                                 end else
                                 begin
                                      mhide;
                                      shadow:=false;
                                      bar13h(139,126,143,128,15);
                                      czekaj(100);
                                      mshow;
                                 end;
                                 mshow;
                            end;
                            {OK}
                            if mousein(x,y,195,70,245,79) and (k=1) then
                            begin
                                 mhide;
                                 ex:=1;
                                 mshow;
                            end;
                            {ANULUJ}
                      until (mousein(x,y,195,84,245,93) and (k=1)) or (ex=1);
                      mhide;
                      putimage13h(pbackgr,50,65);
                      if (ex=1) then qx:=2;
                      mshow;
                 end;
                 {KOLORY}
                 if mousein(x,y,105,20,185,26) and (k=1) then
                 begin
                      mhide;
                      savemrpscreen60x60(239,69,mrpfile2);
                      getimage13h(pbackgr,50,65,231,71);
                      bar13h(50,65,280,135,24);
                      bar13h(56,71,115,130,0);
                      loadmrp(55,70,mrpfile2);
                      bar13h(120,70,164,79,26);
                      outtextxy13h(122,71,1,1,15,' RUN',false);
                      bar13h(120,84,164,93,26);
                      outtextxy13h(122,85,1,1,15,'BEGIN',false);
                      bar13h(120,98,139,107,26);
                      outtextxy13h(125,99,1,1,29,'-',false);
                      bar13h(144,98,164,107,26);
                      outtextxy13h(150,99,1,1,29,'+',false);
                      bar13h(120,112,164,121,26);
                      ilecolor:=1;
                      outtextxy13h(130,113,1,1,29,numstr(ilecolor),false);
                      mshow;
                      button(195,70,1,15,'  OK');
                      button(195,84,1,15,'ANULUJ');
                      ex:=0;
                      repeat
                            getmousepos(x,y,k);
                            x:=x div 2;
                            {-}
                            if mousein(x,y,120,98,139,107) and (k=1) then
                            begin
                                 mhide;
                                 ilecolor:=ilecolor-1;
                                 czekaj(100);
                                 if ilecolor=0 then
                                 begin
                                      mhide;
                                      ilecolor:=ilecolor+1;
                                      mshow;
                                 end;
                                 bar13h(120,112,164,121,26);
                                 outtextxy13h(130,113,1,1,29,numstr(ilecolor),false);
                                 mshow;
                            end;
                            {+}
                            if mousein(x,y,144,98,164,107) and (k=1) then
                            begin
                                 mhide;
                                 ilecolor:=ilecolor+1;
                                 czekaj(100);
                                 if ilecolor=256 then
                                 begin
                                      mhide;
                                      ilecolor:=ilecolor-1;
                                      mshow;
                                 end;
                                 bar13h(120,112,164,121,26);
                                 outtextxy13h(130,113,1,1,29,numstr(ilecolor),false);
                                 mshow;
                            end;
                            {RUN}
                            if mousein(x,y,120,70,164,79) and (k=1) then
                            begin
                                 mhide;
                                 czekaj(200);
                                 bar13h(56,71,115,130,0);
                                 loadmrp(55,70,mrpfile2);
                                 colors13h(56,71,115,130,ilecolor);
                                 mshow;
                            end;
                            {BEGIN}
                            if mousein(x,y,120,84,164,93) and (k=1) then
                            begin
                                 mhide;
                                 bar13h(56,71,115,130,0);
                                 loadmrp(55,70,mrpfile2);
                                 mshow;
                            end;
                            {OK}
                            if mousein(x,y,195,70,245,79) and (k=1) then
                            begin
                                 mhide;
                                 ex:=2;
                                 mshow;
                            end;
                            {ANULUJ}
                      until (mousein(x,y,195,84,245,93) and (k=1)) or (ex=2);
                      mhide;
                      putimage13h(pbackgr,50,65);
                      if (ex=2) then qx:=2;
                      mshow;
                 end;
                 {KOLORY RGB}
                 if mousein(x,y,105,28,185,34) and (k=1) then
                 begin
                      mhide;
                      savemrpscreen60x60(239,69,mrpfile2);
                      getimage13h(pbackgr,50,65,231,90);
                      bar13h(50,65,280,154,24);
                      bar13h(56,71,115,130,0);
                      loadmrp(55,70,mrpfile2);
                      bar13h(120,70,164,79,26);
                      outtextxy13h(122,71,1,1,15,' RUN',false);
                      bar13h(120,84,164,93,26);
                      outtextxy13h(122,85,1,1,15,'BEGIN',false);
                      bar13h(120,98,139,107,26);
                      outtextxy13h(125,99,1,1,29,'-',false);
                      bar13h(144,98,164,107,26);
                      outtextxy13h(150,99,1,1,29,'+',false);
                      bar13h(120,112,164,121,26);
                      bar13h(120+50,98,139+50,107,26);
                      outtextxy13h(125+50,99,1,1,29,'-',false);
                      bar13h(144+50,98,164+50,107,26);
                      outtextxy13h(150+50,99,1,1,29,'+',false);
                      bar13h(120+50,112,164+50,121,26);
                      bar13h(120+100,98,139+100,107,26);
                      outtextxy13h(125+100,99,1,1,29,'-',false);
                      bar13h(144+100,98,164+100,107,26);
                      outtextxy13h(150+100,99,1,1,29,'+',false);
                      bar13h(120+100,112,164+100,121,26);
                      bar13h(120+50,98+28,139+50,107+28,26);
                      outtextxy13h(125+50,99+28,1,1,29,'-',false);
                      bar13h(144+50,98+28,164+50,107+28,26);
                      outtextxy13h(150+50,99+28,1,1,29,'+',false);
                      bar13h(120+50,112+28,164+50,121+28,26);
                      ilergb:=1;
                      r:=1;
                      g:=1;
                      b:=1;
                      outtextxy13h(130,113,1,1,29,numstr(r),false);
                      outtextxy13h(130+50,113,1,1,29,numstr(g),false);
                      outtextxy13h(130+50,113+28,1,1,29,numstr(ilergb),false);
                      outtextxy13h(130+100,113,1,1,29,numstr(b),false);
                      mshow;
                      button(195,70,1,15,'  OK');
                      button(195,84,1,15,'ANULUJ');
                      ex:=0;
                      repeat
                            getmousepos(x,y,k);
                            x:=x div 2;
                            {- R}
                            if mousein(x,y,120,98,139,107) and (k=1) then
                            begin
                                 mhide;
                                 r:=r-1;
                                 czekaj(100);
                                 if r=0 then
                                 begin
                                      mhide;
                                      r:=r+1;
                                      mshow;
                                 end;
                                 bar13h(120,112,164,121,26);
                                 outtextxy13h(130,113,1,1,29,numstr(r),false);
                                 mshow;
                            end;
                            {+ R}
                            if mousein(x,y,144,98,164,107) and (k=1) then
                            begin
                                 mhide;
                                 r:=r+1;
                                 czekaj(100);
                                 if r=256 then
                                 begin
                                      mhide;
                                      r:=r-1;
                                      mshow;
                                 end;
                                 bar13h(120,112,164,121,26);
                                 outtextxy13h(130,113,1,1,29,numstr(r),false);
                                 mshow;
                            end;
                            {- G}
                            if mousein(x,y,120+50,98,139+50,107) and (k=1) then
                            begin
                                 mhide;
                                 g:=g-1;
                                 czekaj(100);
                                 if g=0 then
                                 begin
                                      mhide;
                                      g:=g+1;
                                      mshow;
                                 end;
                                 bar13h(120+50,112,164+50,121,26);
                                 outtextxy13h(130+50,113,1,1,29,numstr(g),false);
                                 mshow;
                            end;
                            {+ G}
                            if mousein(x,y,144+50,98,164+50,107) and (k=1) then
                            begin
                                 mhide;
                                 g:=g+1;
                                 czekaj(100);
                                 if g=256 then
                                 begin
                                      mhide;
                                      g:=g-1;
                                      mshow;
                                 end;
                                 bar13h(120+50,112,164+50,121,26);
                                 outtextxy13h(130+50,113,1,1,29,numstr(g),false);
                                 mshow;
                            end;
                            {- B}
                            if mousein(x,y,120+100,98,139+100,107) and (k=1) then
                            begin
                                 mhide;
                                 b:=b-1;
                                 czekaj(100);
                                 if b=0 then
                                 begin
                                      mhide;
                                      b:=b+1;
                                      mshow;
                                 end;
                                 bar13h(120+100,112,164+100,121,26);
                                 outtextxy13h(130+100,113,1,1,29,numstr(b),false);
                                 mshow;
                            end;
                            {+ B}
                            if mousein(x,y,144+100,98,164+100,107) and (k=1) then
                            begin
                                 mhide;
                                 b:=b+1;
                                 czekaj(100);
                                 if b=256 then
                                 begin
                                      mhide;
                                      b:=b-1;
                                      mshow;
                                 end;
                                 bar13h(120+100,112,164+100,121,26);
                                 outtextxy13h(130+100,113,1,1,29,numstr(b),false);
                                 mshow;
                            end;
                            {- ILERGB}
                            if mousein(x,y,120+50,98+28,139+50,107+28) and (k=1) then
                            begin
                                 mhide;
                                 ilergb:=ilergb-1;
                                 czekaj(100);
                                 if ilergb=0 then
                                 begin
                                      mhide;
                                      ilergb:=ilergb+1;
                                      mshow;
                                 end;
                                 bar13h(120+50,112+28,164+50,121+28,26);
                                 outtextxy13h(130+50,113+28,1,1,29,numstr(ilergb),false);
                                 mshow;
                            end;
                            {+ ILERGB}
                            if mousein(x,y,144+50,98+28,164+50,107+28) and (k=1) then
                            begin
                                 mhide;
                                 ilergb:=ilergb+1;
                                 czekaj(100);
                                 if ilergb=256 then
                                 begin
                                      mhide;
                                      ilergb:=ilergb-1;
                                      mshow;
                                 end;
                                 bar13h(120+50,112+28,164+50,121+28,26);
                                 outtextxy13h(130+50,113+28,1,1,29,numstr(ilergb),false);
                                 mshow;
                            end;
                            {RUN}
                            if mousein(x,y,120,70,164,79) and (k=1) then
                            begin
                                 mhide;
                                 czekaj(200);
                                 bar13h(56,71,115,130,0);
                                 loadmrp(55,70,mrpfile2);
                                 colorsrgb13h(55,71,118,130,r,g,b,ilergb);
                                 mshow;
                            end;
                            {BEGIN}
                            if mousein(x,y,120,84,164,93) and (k=1) then
                            begin
                                 mhide;
                                 bar13h(56,71,115,130,0);
                                 loadmrp(55,70,mrpfile2);
                                 mshow;
                            end;
                            {OK}
                            if mousein(x,y,195,70,245,79) and (k=1) then
                            begin
                                 mhide;
                                 ex:=3;
                                 mshow;
                            end;
                            {ANULUJ}
                      until (mousein(x,y,195,84,245,93) and (k=1)) or (ex=3);
                      mhide;
                      putimage13h(pbackgr,50,65);
                      if (ex=3) then qx:=2;
                      mshow;
                 end;
                 {KOLORY XOR}
                 if mousein(x,y,105,36,185,42) and (k=1) then
                 begin
                      mhide;
                      savemrpscreen60x60(239,69,mrpfile2);
                      getimage13h(pbackgr,50,65,231,71);
                      bar13h(50,65,280,135,24);
                      bar13h(56,71,115,130,0);
                      loadmrp(55,70,mrpfile2);
                      bar13h(120,70,164,79,26);
                      outtextxy13h(122,71,1,1,15,' RUN',false);
                      bar13h(120,84,164,93,26);
                      outtextxy13h(122,85,1,1,15,'BEGIN',false);
                      bar13h(120,98,139,107,26);
                      outtextxy13h(125,99,1,1,29,'-',false);
                      bar13h(144,98,164,107,26);
                      outtextxy13h(150,99,1,1,29,'+',false);
                      bar13h(120,112,164,121,26);
                      ilexor:=1;
                      outtextxy13h(130,113,1,1,29,numstr(ilexor),false);
                      mshow;
                      button(195,70,1,15,'  OK');
                      button(195,84,1,15,'ANULUJ');
                      ex:=0;
                      repeat
                            getmousepos(x,y,k);
                            x:=x div 2;
                            {-}
                            if mousein(x,y,120,98,139,107) and (k=1) then
                            begin
                                 mhide;
                                 ilexor:=ilexor-1;
                                 czekaj(100);
                                 if ilexor=0 then
                                 begin
                                      mhide;
                                      ilexor:=ilexor+1;
                                      mshow;
                                 end;
                                 bar13h(120,112,164,121,26);
                                 outtextxy13h(130,113,1,1,29,numstr(ilexor),false);
                                 mshow;
                            end;
                            {+}
                            if mousein(x,y,144,98,164,107) and (k=1) then
                            begin
                                 mhide;
                                 ilexor:=ilexor+1;
                                 czekaj(100);
                                 if ilexor=256 then
                                 begin
                                      mhide;
                                      ilexor:=ilexor-1;
                                      mshow;
                                 end;
                                 bar13h(120,112,164,121,26);
                                 outtextxy13h(130,113,1,1,29,numstr(ilexor),false);
                                 mshow;
                            end;
                            {RUN}
                            if mousein(x,y,120,70,164,79) and (k=1) then
                            begin
                                 mhide;
                                 czekaj(200);
                                 bar13h(56,71,115,130,0);
                                 loadmrp(55,70,mrpfile2);
                                 xorcolor13h(56,71,115,130,ilexor);
                                 mshow;
                            end;
                            {BEGIN}
                            if mousein(x,y,120,84,164,93) and (k=1) then
                            begin
                                 mhide;
                                 bar13h(56,71,115,130,0);
                                 loadmrp(55,70,mrpfile2);
                                 mshow;
                            end;
                            {OK}
                            if mousein(x,y,195,70,245,79) and (k=1) then
                            begin
                                 mhide;
                                 ex:=4;
                                 mshow;
                            end;
                            {ANULUJ}
                      until (mousein(x,y,195,84,245,93) and (k=1)) or (ex=4);
                      mhide;
                      putimage13h(pbackgr,50,65);
                      if (ex=4) then qx:=2;
                      mshow;
                 end;
                 {WIATR}
                 if mousein(x,y,105,44,185,50) and (k=1) then
                 begin
                      mhide;
                      savemrpscreen60x60(239,69,mrpfile2);
                      getimage13h(pbackgr,50,65,231,71);
                      bar13h(50,65,280,135,24);
                      bar13h(56,71,115,130,0);
                      loadmrp(55,70,mrpfile2);
                      bar13h(120,70,164,79,26);
                      outtextxy13h(122,71,1,1,15,' RUN',false);
                      bar13h(120,84,164,93,26);
                      outtextxy13h(122,85,1,1,15,'BEGIN',false);
                      bar13h(120,98,139,107,26);
                      outtextxy13h(125,99,1,1,29,'-',false);
                      bar13h(144,98,164,107,26);
                      outtextxy13h(150,99,1,1,29,'+',false);
                      bar13h(120,112,164,121,26);
                      ilewiatr:=1;
                      outtextxy13h(130,113,1,1,29,numstr(ilewiatr),false);
                      mshow;
                      button(195,70,1,15,'  OK');
                      button(195,84,1,15,'ANULUJ');
                      kierunek:=nort;
                      bar13h(215,98,225,107,26);
                      outtextxy13h(216,99,1,1,24,'N',false);
                      bar13h(204,98+11,214,107+11,26);
                      outtextxy13h(205,99+11,1,1,29,'W',false);
                      bar13h(226,98+11,236,107+11,26);
                      outtextxy13h(226,99+11,1,1,29,'E',false);
                      bar13h(215,98+22,225,107+22,26);
                      outtextxy13h(216,99+22,1,1,29,'S',false);
                      ex:=0;
                      repeat
                            getmousepos(x,y,k);
                            x:=x div 2;
                            {-}
                            if mousein(x,y,120,98,139,107) and (k=1) then
                            begin
                                 mhide;
                                 ilewiatr:=ilewiatr-1;
                                 czekaj(100);
                                 if ilewiatr=0 then
                                 begin
                                      mhide;
                                      ilewiatr:=ilewiatr+1;
                                      mshow;
                                 end;
                                 bar13h(120,112,164,121,26);
                                 outtextxy13h(130,113,1,1,29,numstr(ilewiatr),false);
                                 mshow;
                            end;
                            {+}
                            if mousein(x,y,144,98,164,107) and (k=1) then
                            begin
                                 mhide;
                                 ilewiatr:=ilewiatr+1;
                                 czekaj(100);
                                 if ilewiatr=256 then
                                 begin
                                      mhide;
                                      ilewiatr:=ilewiatr-1;
                                      mshow;
                                 end;
                                 bar13h(120,112,164,121,26);
                                 outtextxy13h(130,113,1,1,29,numstr(ilewiatr),false);
                                 mshow;
                            end;
                            {NORT}
                            if mousein(x,y,215,98,225,107) and (k=1) then
                            begin
                                 mhide;
                                 kierunek:=nort;
                                 bar13h(215,98,225,107,26);
                                 outtextxy13h(216,99,1,1,24,'N',false);
                                 bar13h(204,98+11,214,107+11,26);
                                 outtextxy13h(205,99+11,1,1,29,'W',false);
                                 bar13h(226,98+11,236,107+11,26);
                                 outtextxy13h(226,99+11,1,1,29,'E',false);
                                 bar13h(215,98+22,225,107+22,26);
                                 outtextxy13h(216,99+22,1,1,29,'S',false);
                                 mshow;
                            end;
                            {WEST}
                            if mousein(x,y,204,98+11,214,107+11) and (k=1) then
                            begin
                                 mhide;
                                 kierunek:=west;
                                 bar13h(215,98,225,107,26);
                                 outtextxy13h(216,99,1,1,29,'N',false);
                                 bar13h(204,98+11,214,107+11,26);
                                 outtextxy13h(205,99+11,1,1,24,'W',false);
                                 bar13h(226,98+11,236,107+11,26);
                                 outtextxy13h(226,99+11,1,1,29,'E',false);
                                 bar13h(215,98+22,225,107+22,26);
                                 outtextxy13h(216,99+22,1,1,29,'S',false);
                                 mshow;
                            end;
                            {EAST}
                            if mousein(x,y,226,98+11,236,107+11) and (k=1) then
                            begin
                                 mhide;
                                 kierunek:=east;
                                 bar13h(215,98,225,107,26);
                                 outtextxy13h(216,99,1,1,29,'N',false);
                                 bar13h(204,98+11,214,107+11,26);
                                 outtextxy13h(205,99+11,1,1,29,'W',false);
                                 bar13h(226,98+11,236,107+11,26);
                                 outtextxy13h(226,99+11,1,1,24,'E',false);
                                 bar13h(215,98+22,225,107+22,26);
                                 outtextxy13h(216,99+22,1,1,29,'S',false);
                                 mshow;
                            end;
                            {SOUTH}
                            if mousein(x,y,215,98+22,225,107+22) and (k=1) then
                            begin
                                 mhide;
                                 kierunek:=south;
                                 bar13h(215,98,225,107,26);
                                 outtextxy13h(216,99,1,1,29,'N',false);
                                 bar13h(204,98+11,214,107+11,26);
                                 outtextxy13h(205,99+11,1,1,29,'W',false);
                                 bar13h(226,98+11,236,107+11,26);
                                 outtextxy13h(226,99+11,1,1,29,'E',false);
                                 bar13h(215,98+22,225,107+22,26);
                                 outtextxy13h(216,99+22,1,1,24,'S',false);
                                 mshow;
                            end;
                            {RUN}
                            if mousein(x,y,120,70,164,79) and (k=1) then
                            begin
                                 mhide;
                                 czekaj(200);
                                 bar13h(56,71,115,130,0);
                                 loadmrp(55,70,mrpfile2);
                                 rectangle13h(55,70,116,131,24);
                                 wind13h(56,71,115,130,ilewiatr,kierunek);
                                 mshow;
                            end;
                            {BEGIN}
                            if mousein(x,y,120,84,164,93) and (k=1) then
                            begin
                                 mhide;
                                 bar13h(56,71,115,130,0);
                                 loadmrp(55,70,mrpfile2);
                                 mshow;
                            end;
                            {OK}
                            if mousein(x,y,195,70,245,79) and (k=1) then
                            begin
                                 mhide;
                                 ex:=5;
                                 mshow;
                            end;
                            {ANULUJ}
                      until (mousein(x,y,195,84,245,93) and (k=1)) or (ex=5);
                      mhide;
                      putimage13h(pbackgr,50,65);
                      if (ex=5) then qx:=2;
                      mshow;
                 end;
                 {PIKSELOZA}
                 if mousein(x,y,105,52,185,59) and (k=1) then
                 begin
                      mhide;
                      savemrpscreen60x60(239,69,mrpfile2);
                      getimage13h(pbackgr,50,65,231,71);
                      bar13h(50,65,280,135,24);
                      bar13h(56,71,115,130,0);
                      loadmrp(55,70,mrpfile2);
                      bar13h(120,70,164,79,26);
                      outtextxy13h(122,71,1,1,15,' RUN',false);
                      bar13h(120,84,164,93,26);
                      outtextxy13h(122,85,1,1,15,'BEGIN',false);
                      mshow;
                      button(195,70,1,15,'  OK');
                      button(195,84,1,15,'ANULUJ');
                      ex:=0;
                      repeat
                            getmousepos(x,y,k);
                            x:=x div 2;
                            {RUN}
                            if mousein(x,y,120,70,164,79) and (k=1) then
                            begin
                                 mhide;
                                 czekaj(200);
                                 bar13h(56,71,115,130,0);
                                 loadmrp(55,70,mrpfile2);
                                 pixeloze13h(56,71,115,130);
                                 mshow;
                            end;
                            {BEGIN}
                            if mousein(x,y,120,84,164,93) and (k=1) then
                            begin
                                 mhide;
                                 bar13h(56,71,115,130,0);
                                 loadmrp(55,70,mrpfile2);
                                 mshow;
                            end;
                            {OK}
                            if mousein(x,y,195,70,245,79) and (k=1) then
                            begin
                                 mhide;
                                 ex:=6;
                                 mshow;
                            end;
                            {ANULUJ}
                      until (mousein(x,y,195,84,245,93) and (k=1)) or (ex=6);
                      mhide;
                      putimage13h(pbackgr,50,65);
                      if (ex=6) then qx:=2;
                      mshow;
                 end;
           until (k=2) or (qx=2);
           mhide;
           putimage13h(screen,0,0);
           if (ex=1) then
           begin
                blur13h(240,70,300,129,ileblur,shadow);
                savemrpscreen60x60(239,69,mrpfile2);
                pole2;
                loadmrp2(2,13,mrpfile2);
                ex:=0;
           end;
           if (ex=2) then
           begin
                colors13h(240,70,299,129,ilecolor);
                savemrpscreen60x60(239,69,mrpfile2);
                pole2;
                loadmrp2(2,13,mrpfile2);
                ex:=0;
           end;
           if (ex=3) then
           begin
                colorsrgb13h(240,70,302,129,r,g,b,ilergb);
                savemrpscreen60x60(239,69,mrpfile2);
                pole2;
                loadmrp2(2,13,mrpfile2);
                ex:=0;
           end;
           if (ex=4) then
           begin
                xorcolor13h(240,70,299,129,ilexor);
                savemrpscreen60x60(239,69,mrpfile2);
                pole2;
                loadmrp2(2,13,mrpfile2);
                ex:=0;
           end;
           if (ex=5) then
           begin
                wind13h(240,70,299,129,ilewiatr,kierunek);
                savemrpscreen60x60(239,69,mrpfile2);
                pole2;
                loadmrp2(2,13,mrpfile2);
                ex:=0;
           end;
           if (ex=6) then
           begin
                pixeloze13h(240,70,299,129);
                savemrpscreen60x60(239,69,mrpfile2);
                pole2;
                loadmrp2(2,13,mrpfile2);
                ex:=0;
           end;
           button(105,1,1,29,'FILTRY');
           bar13h(189,29,315,38,26);
           outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
           bar13h(189,15,315,24,26);
           mshow;
      end;
      end;
      if menu=false then
      begin
      end;
end;

procedure pomoc;
procedure aboutinfo;
procedure tekst(x, y, a, b : integer; c : byte; text : string; jest : boolean);
begin
     if jest=true then
     begin
          outtextxy13h(x,y,a,b,c,text,false);
     end;
end;
var
   sy1, sy2, sy3, sy4, sy5, sy6, sy7 : integer;
   tx1, tx2, tx3, tx4, tx5, tx6, tx7 : boolean;
   kx1, kx2, kx3, kx4, kx5, kx6, kx7 : byte;
begin
     getimage13h(pbackgr,50,65,280,154);
     bar13h(50,65,280,154,24);
     bar13h(55,70,199,149,0);
     rysunekglowny(198,45);
     button(214,140,1,15,'  OK');
     sy1:=159;
     sy2:=168;
     sy3:=177;
     sy4:=186;
     sy5:=195;
     sy6:=204;
     sy7:=213;
     tx1:=false;
     tx2:=false;
     tx3:=false;
     tx4:=false;
     tx5:=false;
     tx6:=false;
     tx7:=false;
     kx1:=18;
     kx2:=18;
     kx3:=18;
     kx4:=18;
     kx5:=18;
     kx6:=18;
     kx7:=18;
     repeat
           getmousepos(x,y,k);
           x:=x div 2;
           outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
           if (ax<>x) or (ay<>y) then
           begin
                mhide;
                ax:=x;
                ay:=y;
                bar13h(189,29,315,38,26);
                mshow;
           end;
           sy1:=sy1-1;
           sy2:=sy2-1;
           sy3:=sy3-1;
           sy4:=sy4-1;
           sy5:=sy5-1;
           sy6:=sy6-1;
           sy7:=sy7-1;
           tekst(58,sy1,1,1,kx1,'   PAINT vBETA',tx1);
           tekst(54,sy2,1,1,kx2,'        by  ',tx2);
           tekst(54,sy3,1,1,kx3,'       REGi  ',tx3);
           tekst(50,sy4,1,1,kx4,'',tx4);
           tekst(54,sy5,1,1,kx5,'   PROGRAM JEST',tx5);
           tekst(54,sy6,1,1,kx6,' ROZPROWADZANY NA',tx6);
           tekst(58,sy7,1,1,kx7,'ZASADACH FREEWARE',tx7);
           czekaj(50);
           outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
           tekst(58,sy1,1,1,0,'   PAINT vBETA',tx1);
           tekst(54,sy2,1,1,0,'        by  ',tx2);
           tekst(54,sy3,1,1,0,'       REGi  ',tx3);
           tekst(50,sy4,1,1,0,'',tx4);
           tekst(54,sy5,1,1,0,'   PROGRAM JEST',tx5);
           tekst(54,sy6,1,1,0,' ROZPROWADZANY NA',tx6);
           tekst(58,sy7,1,1,0,'ZASADACH FREEWARE',tx7);
           if sy1=141 then begin tx1:=true; end;
           if sy1=132 then begin kx1:=19; end;
           if sy1=123 then begin kx1:=20; end;
           if sy1=114 then begin kx1:=21; end;
           if sy1=105 then begin kx1:=20; end;
           if sy1=96 then begin kx1:=19; end;
           if sy1=87 then begin kx1:=18; end;
           if sy2=141 then begin tx2:=true; end;
           if sy2=132 then begin kx2:=19; end;
           if sy2=123 then begin kx2:=20; end;
           if sy2=114 then begin kx2:=21; end;
           if sy2=105 then begin kx2:=20; end;
           if sy2=96 then begin kx2:=19; end;
           if sy2=87 then begin kx2:=18; end;
           if sy3=141 then begin tx3:=true; end;
           if sy3=132 then begin kx3:=19; end;
           if sy3=123 then begin kx3:=20; end;
           if sy3=114 then begin kx3:=21; end;
           if sy3=105 then begin kx3:=20; end;
           if sy3=96 then begin kx3:=19; end;
           if sy3=87 then begin kx3:=18; end;
           if sy4=141 then begin tx4:=true; end;
           if sy4=132 then begin kx4:=19; end;
           if sy4=123 then begin kx4:=20; end;
           if sy4=114 then begin kx4:=21; end;
           if sy4=105 then begin kx4:=20; end;
           if sy4=96 then begin kx4:=19; end;
           if sy4=87 then begin kx4:=18; end;
           if sy5=141 then begin tx5:=true; end;
           if sy5=132 then begin kx5:=19; end;
           if sy5=123 then begin kx5:=20; end;
           if sy5=114 then begin kx5:=21; end;
           if sy5=105 then begin kx5:=20; end;
           if sy5=96 then begin kx5:=19; end;
           if sy5=87 then begin kx5:=18; end;
           if sy6=141 then begin tx6:=true; end;
           if sy6=132 then begin kx6:=19; end;
           if sy6=123 then begin kx6:=20; end;
           if sy6=114 then begin kx6:=21; end;
           if sy6=105 then begin kx6:=20; end;
           if sy6=96 then begin kx6:=19; end;
           if sy6=87 then begin kx6:=18; end;
           if sy7=141 then begin tx7:=true; end;
           if sy7=132 then begin kx7:=19; end;
           if sy7=123 then begin kx7:=20; end;
           if sy7=114 then begin kx7:=21; end;
           if sy7=105 then begin kx7:=20; end;
           if sy7=96 then begin kx7:=19; end;
           if sy7=87 then begin kx7:=18; end;
           if (x<210) and (x>45) and (y<159) and (y>60) then
           begin
                mhide;
                bar13h(55,70,199,149,0);
                tekst(58,sy1-1,1,1,kx1,'   PAINT vBETA',tx1);
                tekst(54,sy2-1,1,1,kx2,'        by  ',tx2);
                tekst(54,sy3-1,1,1,kx3,'       REGi  ',tx3);
                tekst(50,sy4-1,1,1,kx4,'',tx4);
                tekst(54,sy5-1,1,1,kx5,'   PROGRAM JEST',tx5);
                tekst(54,sy6-1,1,1,kx6,' ROZPROWADZANY NA',tx6);
                tekst(58,sy7-1,1,1,kx7,'ZASADACH FREEWARE',tx7);
                mshow;
           end;
           if sy1=75 then
           begin
                tx1:=false;
                sy1:=159;
           end;
           if sy2=75 then
           begin
                tx2:=false;
                sy2:=159;
           end;
           if sy3=75 then
           begin
                tx3:=false;
                sy3:=159;
           end;
           if sy4=75 then
           begin
                tx4:=false;
                sy4:=159;
           end;
           if sy5=75 then
           begin
                tx5:=false;
                sy5:=159;
           end;
           if sy6=75 then
           begin
                tx6:=false;
                sy6:=159;
           end;
           if sy7=75 then
           begin
                tx7:=false;
                sy7:=159;
           end;
     until mousein(x,y,214,140,264,149) and (k=1);
     mhide;
     putimage13h(pbackgr,50,65);
     bar13h(157,11,221,20,25);
     outtextxy13h(157,12,1,1,15,'ABOUT...',false);
     mshow;
     end;
begin
     if mousein(x,y,157,1,207,9) and (k=1) then
     begin
          mhide;
          button(157,1,4,24,'POMOC');
          getimage13h(ppomoc,157,11,221,20);
          bar13h(157,11,221,20,25);
          outtextxy13h(157,12,1,1,15,'ABOUT...',false);
          mshow;
          czekaj(300);
          repeat
                getmousepos(x,y,k);
                x:=x div 2;
                outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
                if (ax<>x) or (ay<>y) then
                begin
                     mhide;
                     ax:=x;
                     ay:=y;
                     bar13h(189,29,315,38,26);
                     mshow;
                end;
                {ABOUT...}
                if mousein(x,y,157,11,221,20) and (k=1) then
                begin
                     aboutinfo;
                end;
          until k=2;
          mhide;
          button(1,1,8,29,'PLIK');
          putimage13h(ppomoc,157,11);
          bar13h(189,15,315,24,26);
          mshow;
     end;
end;

begin
deletemrp;
init13h;
kolor:=1;
clrscr13h(0);
bar13h(0,0,resx-1,11,7);
button(1,1,8,29,'PLIK');
menu:=true;
if menu=true then
begin
button(53,1,1,29,'EDYCJA');
button(105,1,1,29,'FILTRY');
end;
button(157,1,4,29,'POMOC');
if menu=false then
begin
button(53,1,1,22,'EDYCJA');
button(105,1,1,22,'FILTRY');
end;
if menu=true then
begin
pole(15);
bar13h(189,15,315,24,26);
outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
bar13h(189,29,315,38,26);
outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
bar13h(240,50,300,59,26);
outtextxy13h(240,51,1,1,29,'KOL='+NumStr(Kolor),false);
bar13h(228,50,235,59,26);
outtextxy13h(228,51,1,1,29,'-',false);
bar13h(305,50,313,59,26);
outtextxy13h(305,51,1,1,29,'+',false);
bar13h(240,70,299,129,0);
kolory;
end;
mshow;
setmousepos(600 div 2,200 div 2);
getpointer;
kx:=189;
ky:=43;
rectangle13h(kx,1+ky,kx+4,1+ky+3,15);
cx:=kx;
cy:=ky;
kol:=kolor;
kopiuj:=false;
menuo:=false;
repeat
      getmousepos(x,y,k);
      x:=x div 2;
      outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
      if (ax<>x) or (ay<>y) then
      begin
           mhide;
           ax:=x;
           ay:=y;
           bar13h(189,29,315,38,26);
           bar13h(189,15,315,24,26);
           mshow;
      end;
      if menu=true then
      begin
{pix} if mousein(x,y,5,17,61*3,65*3) and (k=1) then
      begin
           mhide;
           bar13h(189,15,315,24,26);
           outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
           bar13h(189,29,315,38,26);
           outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
           mx:=(x-2) div 3;
           my:=(y-5) div 3;
           bar13h(2+mx*3,4+my*3,3+mx*3,5+my*3,kolor);
           putpixel13h(mx+239,my+66,kolor);
           mshow;
      end;
{cut} if mousein(x,y,5,17,61*3,65*3) and (k=2) then
      begin
           mhide;
           bar13h(189,15,315,24,26);
           outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
           bar13h(189,29,315,38,26);
           outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
           mx:=(x-2) div 3;
           my:=(y-5) div 3;
           bar13h(2+mx*3,4+my*3,3+mx*3,5+my*3,0);
           putpixel13h(mx+239,my+66,0);
           mshow;
      end;
      end;
      {PLIK}
      if mousein(x,y,1,1,51,9) and (k=1) then
      begin
           mhide;
           button(1,1,8,24,'PLIK');
           getimage13h(pplik,1,11,100,44);
           bar13h(1,11,97,52,25);
           outtextxy13h(1,12,1,1,15,'NOWY',false);
           outtextxy13h(1,20,1,1,15,'OTWORZ',false);
           outtextxy13h(5,19,1,1,15,'   '' ',false);
           outtextxy13h(1,28,1,1,15,'ZAPISZ *.MRP',false);
           outtextxy13h(1,36,1,1,15,'ZAPISZ *.PAS',false);
           outtextxy13h(1,44,1,1,15,'WYJSCIE',false);
           outtextxy13h(5,43,1,1,15,'   ''   ',false);
           mshow;
           czekaj(300);
           outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
           ex:=0;
           repeat
                 getmousepos(x,y,k);
                 x:=x div 2;
                 outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
                 if (ax<>x) or (ay<>y) then
                 begin
                      mhide;
                      ax:=x;
                      ay:=y;
                      bar13h(189,29,315,38,26);
                      mshow;
                 end;
                 {NOWY}
                 if mousein(x,y,1,12,97,18) and (k=1) then
                 begin
                      k:=2;
                      ex:=1;
                 end;
                 {OTWORZ}
                 if mousein(x,y,1,20,97,26) and (k=1) then
                 begin
                      mhide;
                      getimage13h(pbackgr,100,70,260,130);
                      bar13h(100,70,260,130,24);
                      outtextxy13h(105,75,1,1,15,'PODAJ NAZWE PLIKU:',false);
                      outtextxy13h(108,76,1,1,15,'          ,',false);
                      bar13h(105,94,255,103,27);
                      str13h(113,95,18,27,15,8,nameopen,normal);
                      menuo:=true;
                      k:=2;
                      putimage13h(pbackgr,100,70);
                     mshow;
                 end;
                 {ZAPISZ *.MRP}
                 if mousein(x,y,1,28,97,34) and (k=1) then
                 begin
                      mhide;
                      getimage13h(pbackgr,80,75,220,100);
                      bar13h(80,80,220,100,24);
                      mshow;
                      mhide;
                      outtextxy13h(80,85,1,1,29,'NAME:',false);
                      outtextxy13h(188,85,1,1,29,'.mrp',false);
                      bar13h(189,29,315,38,26);
                      outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
                      str13h(122,85,8,24,29,8,namesave,normal);
                      mshow;
                      if czyplikistnieje(namesave+'.mrp') then
                      begin
                           mhide;
                           bar13h(80,77,220,103,24);
                           outtextxy13h(78,78,1,1,29,'   CZY ZASTAPIC',false);
                           outtextxy13h(78,86,1,1,29,' ISTNIEJACY PLIK?',false);
                           button(90,94,5,29,' TAK');
                           button(160,94,5,29,' NIE');
                           mshow;
                           ex:=0;
                           repeat
                                 getmousepos(x,y,k);
                                 x:=x div 2;
                                 outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
                                 if (ax<>x) or (ay<>y) then
                                 begin
                                      mhide;
                                      ax:=x;
                                      ay:=y;
                                      bar13h(189,29,315,38,26);
                                      mshow;
                                 end;
                                 {TAK}
                                 if mousein(x,y,90,94,140,102) and (k=1) then
                                 begin
                                      mhide;
                                      savemrpscreen60x60(239,69,namesave+'.mrp');
                                      mshow;
                                      ex:=1;
                                 end;
                                 {NIE}
                           until (mousein(x,y,160,94,210,102) and (k=1)) or (ex=1);
                           mhide;
                           putimage13h(pbackgr,80,75);
                           mshow;
                      end else
                      begin
                           mhide;
                           savemrpscreen60x60(239,69,namesave+'.mrp');
                           putimage13h(pbackgr,80,75);
                           mshow;
                      end;
                 end;
                 {ZAPISZ *.PAS}
                 if mousein(x,y,1,36,97,42) and (k=1) then
                 begin
                 end;
                 {WYJSCIE}
                 if mousein(x,y,1,44,97,51) and (k=1) then
                 begin
{                      mhide;
                      wyjscie;
                      mshow;
                      timer.start;
                      repeat
                            getmousepos(x,y,k);
                            x:=x div 2;
                            outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
                            if (ax<>x) or (ay<>y) then
                            begin
                                 mhide;
                                 ax:=x;
                                 ay:=y;
                                 bar13h(189,29,315,38,26);
                                 mshow;
                            end;
                      until timer.stop=3;}
                      freepointer;
                      close13h;
                      halt;
                 end;
           until k=2;
           mhide;
           button(1,1,8,29,'PLIK');
           putimage13h(pplik,1,11);
           bar13h(189,15,315,24,26);
           if menuo=true then
           begin
                pole2;
                bar13h(240,70,299,129,0);
                loadmrp2(2,13,nameopen+'.mrp');
                loadmrp(239,69,nameopen+'.mrp');
           end;
           if menuo=false then
           begin
           end;
           if ex=1 then
           begin
                pole2;
                bar13h(189,15,315,24,26);
                outtextxy13h(189,16,1,1,29,'Mx='+NumStr(Mx)+' My='+NumStr(My),false);
                bar13h(189,29,315,38,26);
                outtextxy13h(189,30,1,1,29,'X='+NumStr(X)+' Y='+NumStr(Y),false);
                bar13h(240,50,300,59,26);
                outtextxy13h(240,51,1,1,29,'KOL='+NumStr(Kolor),false);
                bar13h(228,50,235,59,26);
                outtextxy13h(228,51,1,1,29,'-',false);
                bar13h(305,50,313,59,26);
                outtextxy13h(305,51,1,1,29,'+',false);
                bar13h(240,70,299,129,0);
                kolory;
           end;
           menuo:=false;
           mshow;
      end;
      edycja;
      filtry;
      pomoc;
      kolorbar;
    {  kolorypola;}
    {  kolory2;}
until ex=255;
freepointer;
close13h;
end.