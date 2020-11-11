{Jet Release 1.1 Scada with USB Disk}
{Version Beta 1.10}
{Date 19 - Oct - 2013}
{Time 12:30}
{Writen by Somchai Boonyawanichgul}
Program JET;
Uses  DOS,Rdelay,Crt,Graph,CMenu,Rjchai,Comm_TP4;
Label run,Rec,Loop,TheEnd,First,Second,PAgain,StartShow,V2;
Type  Jetdat = Record
                 Project : String[12];
                 JTime : String[8];
                 Slurry : Boolean;
                 JDate : String[11];
                 JDepth,JDrill : String[4];
                 JStroke,JPress,JFlow : String[5];
                 JCement : String[6];
               End;
Type  Fnames = Record
                 FProject:String[30];
                 Fbelong:String[30];
                 FWork:String[30];
                 FCDepth,FCStroke,FCPress,FCDrill: Real;
                 FCFlow,FCBat,FCCement,SamRate,FWC : Real;
                 FY,FMN,FD:Word;
               End;
Type  Detail = Record
                 DPrjName : String[30];
                 DBelong : String[30];
                 DWork : String[30];
                 DWC : String[5];
                 DSC : String[5];
                 DSP : String[5];
               End;
Type  ID = Record
             ProjectID : String;
             PNo : Integer;
           End;
Var   FJ : File of Jetdat;
      JD : Jetdat;
      FN : File of Fnames;
      FF : Fnames;
      FID : File of ID;
      Proj : ID;
      FD : File of Detail;
      DT : Detail;
var  pic1,pic2:pointer;
     a,b,c,d,x,y,z,u,zz,xd,xv: Integer;
     size:word;
Var  GraphDriver,GraphMode,no : Integer;
     belong,Work,Batname : String;
     CSRatio,WCRatio,Sampling,WC,CRate : Real;
     ValueA,ValueB,ValueC,ValueD,ValueE,ValueF,ValueG,ValueH : Word;
     Comm,XComm,YComm,ZComm,SD,ProjectNumber,TID : Integer;
     Counter,Dsize,FreeB : LongInt;
     Ch1,Ch2,Ch3,Ch4,Ch5,Ch6,Ch7,Ch8 : INTEGER;
     V1,D1,D3,D4,D5,D6,D7,D8,TestP,JetStatus,RecCount : Boolean;
     SkrewValve, BatchValve, MixValve, MixWaterV, TestDComm : Boolean;
     WaterV, WlevelH, WlevelL,RealPlot,FirstPlot, InitComm : Boolean;
     Depth,Stroke,Pressure,Drill : Real;
     Flow,Spt1,Spt2   : Real;
     Volume,Bat,MaxDepth,Cement,XCement,FBat : Real;
     TDepth,TStroke,TPressure,TDrill,TFlow,TCRate : String;
     TVolume,TBat,TMaxDepth,TCement,TSampling,TTSam : String;
     H,M,S,SS,STH,STM,STS,STSS,SH,SM,SSS,YY,MM,DD,DOW : Word;
     TH,TM,TS,TSH,TSM,TSS,TYY,TMM,TDD,Date : String;
     DoDepth,LPress,RPress,DoBat,XBat,LBat,I,J : Integer;
     ConDepth,ConStroke,ConPress,ConDrill,ConBat,ConFlow : Real;
     TConDep,TConDepQ,TConDepH,TConDepHQ : String;
     TConStroke,TConPress,TConDrill,TWC,TCSRatio : String;
     TConBat,TConDepth,TConFlow,Dirtory,Time : String;
     BV,WV,WT1V,MV,K,OldDepth,FIXBV,FixV1,CV1,LogOn : Integer;
     TCP,TCT,MaxBat,CCement,SR : Real;
     TBP,TBT,Err,PBt : Integer;
     TTCP,TTCT,TTBP,TTBT,InString,PName,PShow,CShow : String;
     TickTime : LongInt Absolute $40:$6C;
     Tick,SCT,STT : LongInt;
     RCH,RCM,RCS,RCSS,WCH,WCM,WCS,WCSS : Word;
     JetTime : Real;
     InChar : Char;
     SProject,Sbelong,SWork,Project,PjN,NCol,Column,SecCode,Xcode : String;
     FindFile,Dspeed,Beep,CDspeed,STCount,Response,DirCount : Integer;
     CY,CMN,CD,CDow,CH,CM,CS,CSS : Word;
     AnalogOK,DigitalOK,DrvStatus,PrintBat,Rekord : Boolean;
     ColDetail,WCR,SC,SP,Projec,SetPoint1,SetPoint2,Tspt1,Tspt2 : String;
     Btd : array[1..300] of real;
     Ttd : array[1..300] of String[8];
     CommDL,CommBat,CommDpt,CommStk: word;

Function Getnumber(PutX,PutY,PutN,PutC:Integer):String;
Label OutGet;
Var GetNum,CodeNum : Integer;
    StrNum : String;
Begin
     Repeat
     StrNum := ReadStr(PutX,PutY,PutN,'E',PutC);
     If StrNum = '' then Goto OutGet;
     Val(StrNum,GetNum,CodeNum);
     Until CodeNum <> 1;
OutGet:
     Getnumber := StrNum;
End;

Function RealToStr(Value:Real):String;
var Result : String;
begin
  Str(Value:4:1,Result);
  RealToStr := Result;
end;

Function ChUSBDrv(DrV:Word):Boolean;
Var      Dr : Word;
Begin
  Dr := Drv;
  Dsize := Disksize(Dr);
  FreeB := DiskFree(Dr);
  If Dsize = -1 then ChUSBDrv := False else ChUSBDrv := True;
End;

Function ChDrv(DrV:Word):Boolean;
Label    StCh,Got;
Var      Dsize,FreeB : Longint;
         TDsize,TFree : String;
         Key : Char;
         Dr,Roud : Word;
Begin
  Dr := Drv;
  Roud := 1;
StCh:
  Dsize := Disksize(Dr);
  FreeB := DiskFree(Dr);
  Str(Dsize,TDsize);
  Str(FreeB,TFree);
  SetTextStyle(2,0,4);
    If Dsize = -1 then
       Begin
         If Roud = 1 then
         Begin
         SetColor(11);
         ClsGr(70,180,550,285);
         Rectangle(100,180,520,285);
         SetTextStyle(0,0,1);
         SetColor(12);
         TextXY(200,210,'������� Disk 㹪�ͧ��ҹ��(A) !!!!',12);
         TextXY(200,235,'�����������º�������ǡ����� ENTER',15);
         Readln;
         Roud := Roud+1;
         ClsGr(70,180,550,285);
         Goto StCh;
         End
         Else
         Begin
           SetColor(11);
           ClsGr(70,180,550,285);
           Rectangle(100,180,520,285);
           SetTextStyle(0,0,1);
           TextXY(182,200,'������� Disk 㹪�ͧ��ҹ��(A) !!!!',13);
           TextXY(195,225,'�����������º�������ǡ����� ENTER',12);
           TextXY(193,250,'���͡����� N ����͵�ͧ��÷ӧҹ����',15);
         End;
         Key := Upcase(Readkey);
         If Key = Char(78) then
         Begin
           ChDrv := False;
           ClsGr(70,180,550,285);
           Goto Got;
         End;
         ClsGr(70,180,550,285);
         Goto StCh;
       end;
         SetColor(11);
         ClsGr(70,180,550,285);
         Rectangle(100,180,520,285);
         SetTextStyle(2,0,4);
         SetColor(12);
         TextXY(180,200,'��ͧ��ҹ��(D) ���� Disk ���º��������',13);
         TextXY(200,225,'�����آͧ�蹷����� = ',12);
         TextXY(200,250,'�����ط������� ���� = ',15);
         OutTextXY(360,233,TDsize);
         SetColor(15);
         OutTextXY(360,257,TFree);
         If FreeB < 20000 then
         Begin
           TextXY(160,275,'�����ҧ��������͹����Թ� �ô����¹������',15);
           Readln;
           Goto Stch;
         End
         Else ChDrv := True;
         Delay(2000);
Got:     ClsGr(70,180,550,311);
End;

Procedure CreatJet;
Label Startpoint;
Var JPro : String;
    JFX : PathStr;
    key : Char;
    CErr : Integer;
Begin
Startpoint:
     Rectangle(330,200,610,230);
     ClsGr(331,201,609,229);
     SetTextStyle(2,0,4);
     MoveTo(340,207);
     Outtext('Change Column Name From:');
     MoveTo(540,207);
     Outtext(CShow);
     MoveTo(424,224);
     Outtext('To:');
     SetViewPort(351,201,599,229,True);
     JPro := ReadStr(57,14,8,'E',15);
     Column := Dirtory+JPro+'.dat';
     ClsGr(330,200,610,230);
     JFX := FSearch(Column,GetEnv('PATH'));
     If JFX = '' then
     Begin
       Assign(FJ,Column);
       Rewrite(FJ);
       Write(FJ,JD);
       Close(FJ);
       RecCount := False;
     End
     Else
     Begin
       SetViewPort(320,200,620,300,True);
       ClsGr(321,200,619,299);
       Rectangle(320,200,620,300);
       TextXY(405,210,'������ҫ�ӡѺ�������!',12);
       TextXY(340,230,'������',15);
       SetColor(10);
       OutTextXY(382,243,'Y');
       TextXY(400,230,'��ҵ�ͧ��úѹ�֡�����ŷѺ���������',15);
       TextXY(332,250,'������',15);
       OutTextXY(372,263,'R');
       TextXY(387,250,'��ҵ�ͧ��úѹ�֡�����ŵ�ͨҡ���������',15);
       TextXY(370,270,'������',15);
       OutTextXY(412,283,'N');
       TextXY(432,270,'��ҵ�ͧ��õ�駪����������',15);
       Repeat
         Key := Upcase(ReadKey);
         If Key = Char(78) then GoTo Startpoint;
         If Key = Char(82) then
         Begin
           Assign (FJ,Column);
           Reset(FJ);
           Seek(FJ,Filesize(FJ)-1);
           Read(FJ,JD);
             TCement := JD.JCement;
           Close(FJ);
           Val(TCement,Cement,CErr);
           RecCount := True;
         End;
         If Key = Char(89) then RecCount := False;
       Until (Key = Char(89)) or (Key = Char(82));
     End;
End;

Function OpenProj:String;
Var
    OSProject : String;
    SFX : PathStr;
Begin
     SFX := FSearch('C:\jet\project.IDF',GetEnv('PATH'));
     If SFX = '' then
     Begin
      Assign(FID,'C:\jet\project.IDF');
      Rewrite(FID);
      Proj.ProjectID := 'C:\jet\first.prj';
      Write(FID,Proj);
      Close(FID);
      GetDate(YY,MM,DD,Dow);
     Assign(FN,'C:\jet\first.prj');
     Rewrite(FN);
       FF.FY := YY;
       FF.FMN := MM;
       FF.FD := DD;
       FF.FProject := 'First';
       FF.Fbelong := 'XXXX';
       FF.FWork := 'XXXX';
       FF.FCCement := 250;
       FF.FWC := 1.1;
       FF.SamRate := 2;
       FF.FCDepth := 50;
       FF.FCStroke := 200;
       FF.FCPress := 1000;
       FF.FCDrill := 20;
       FF.FCFlow := 2.365;
       FF.FCBat := 300;
     Write(FN,FF);
     Close(FN);
      Assign(FID,'C:\jet\project.IDF');
      Reset(FID);
      Seek(FID,Filesize(FID)-1);
      Read(FID,Proj);
        OSProject := Proj.ProjectID;
      Close(FID);
      OpenProj := OSProject;
      MkDir('C:\jet\first');
     End
     Else
     Begin
      Assign(FID,'C:\jet\project.IDF');
      Reset(FID);
      Seek(FID,Filesize(FID)-1);
      Read(FID,Proj);
        OSProject := Proj.ProjectID;
      Close(FID);
      OpenProj := OSProject;
     end;
End;

Procedure CreatDJet(Ncol,Nshow:String);
var infile, outfile, IFile, OFile : file;
    Numread, Numwrite : word;
    buf : array[1..10000] of char;
    SourceName, DestName, PrjN : String;
    SearchFile : PathStr;
    Cheq : Boolean;
begin
  Cheq := ChDrv(4);
  If Cheq = True then
  Begin
  SourceName := NCol;
  DestName := NShow;
  DestName := 'D:\'+DestName+'.dat';
  assign(infile, SourceName);
  reset(infile, 1);
  assign(outfile, DestName);
  rewrite(outfile, 1);
  repeat
    blockread(infile, buf, Sizeof(buf), Numread);
    blockwrite(outfile, buf, Numread, Numwrite);
  until (Numread = 0) or (Numwrite <> Numread);
  close(infile);
  close(outfile);

  DestName := 'D:\Road.prj';
    assign(FD, DestName);
    Rewrite(FD);
      DT.DPrjName := PName;
      DT.DBelong := belong;
      DT.DWork := Work;
      DT.DWC := WCR;
      DT.DSC := SC;
      DT.DSP := SP;
    Write(FD,DT);
    close(FD);
  End;
End;

Procedure CreatBJet(Ncol,Nshow:String);
var infile, outfile, IFile, OFile : file;
    Numread, Numwrite : word;
    buf : array[1..10000] of char;
    SourceName, DestName, PrjN : String;
    SearchFile : PathStr;
    Cheq : Boolean;
begin
  Cheq := ChDrv(4);
  If Cheq = True then
  Begin
  SourceName := NCol;
  DestName := NShow;
  assign(infile, SourceName);
  reset(infile, 1);
  assign(outfile, DestName);
  rewrite(outfile, 1);
  repeat
    blockread(infile, buf, Sizeof(buf), Numread);
    blockwrite(outfile, buf, Numread, Numwrite);
  until (Numread = 0) or (Numwrite <> Numread);
  close(infile);
  close(outfile);
  End;
End;

Procedure ProjConst;
Begin
     Project := OpenProj;
     Assign(FN,Project);
     FindFile := 0;
     Reset(FN);
       Seek(FN,Findfile);
       Read(FN,FF);
       PName := FF.FProject;
       Belong := FF.Fbelong;
       Work := FF.FWork;
       ConDepth := FF.FCDepth;
       ConStroke := FF.FCStroke;
       ConPress := FF.FCPress;
       ConDrill := FF.FCDrill;
       ConFlow := FF.FCFlow;
       ConBat := FF.FCBat;
       CSRatio := FF.FCCement;
       Sampling := FF.SamRate;
       WCRatio := FF.FWC;
     Close(FN);
End;

Procedure ProjName(PName:String);
Label L,Outside;
Var PNFile,PD,SubPNErr : Integer;
    PSName,TWC,TSamrate,TCCement,AFile,BFile : String;
    PNKey : Char;
    WC,SR,CCement : Real;
    Sbelong,SWork,ProjectName,PSDName : String;
    State : Boolean;
    SPNProject : array[0..50] of String[22];
Begin
     PSName := PName;
     Assign(FID,'C:\jet\project.IDF');
     Reset(FID);
     PNFile := Filesize(FID)-1;
     SetTextStyle(2,0,4);
     Repeat
       Seek(FID,PNFile);
       Read(FID,Proj);
       SPNProject[PNFile] := Proj.ProjectID;
       If SPNProject[PNFile] = PSName then
       Begin
           SetViewPort(330,200,610,260,True);
           ClsGr(331,200,609,259);
           Rectangle(330,200,610,260);
           MoveTo(365,210);
           Outtext('This Project Already Exist');
           Moveto(375,230);
           OutText('Work with this Project?');
           Moveto(365,250);
           OutText('Press Y if ok N if not ok!');
         PNKey := Upcase(ReadKey);
         If PNKey = Char(89) then
         Begin
           AFile := SPNProject[PNFile];
           BFile := Project;
           Seek(FID,Filesize(FID)-1);
           Proj.ProjectID := AFile;
           Write(FID,Proj);
           Seek(FID,PNFile);
           Proj.ProjectID := BFile;
           Write(FID,Proj);
           Close(FID);
           Project := AFile;
           Goto Outside;
         End;
         If PNKey = Char(78) then Goto Outside;
     End;
       Dec(PNFile);
     Until PNFile < 0;
     PSDName := PSName;
     PD := Length(PSDName);
     Delete(PSDName,PD-3,4);
     Project := PSName;
     MkDir(PSDName);
     Seek(FID,Filesize(FID));
     ProjectNumber := Filesize(FID);
     Proj.ProjectID := Project;
     Proj.PNo := ProjectNumber;
     Write(FID,Proj);
     Close(FID);
           Rectangle(330,200,610,250);
           ClsGr(331,201,609,249);
           TextXY(340,212,'�����ç���:',15);
           ProjectName := ReadStr(54,14,30,'T',15);
           ClsGr(331,201,609,249);
           TextXY(340,212,'������Ңͧ�ç���:',15);
           Sbelong := ReadStr(60,14,30,'T',15);
           ClsGr(331,201,609,249);
           TextXY(340,212,'���ͼ���Ѻ��ҧ:',15);
           SWork := ReadStr(54,14,30,'T',15);
           ClsGr(331,201,609,249);
           TextXY(340,212,'�ѵ����ǹ�������/�Թ:',15);{Cement Ratio Kgs/MMM}
           TextXY(520,212,'Kgs/QM',15);
           TCCement := Getnumber(60,14,3,15);
           if TCCement = '' then TCCement := '250';
           Val(TCCement,CCement,SubPNErr);
           ClsGr(331,201,609,249);
           TextXY(340,212,'�ѵ����ǹ���/�������:',15); {W/C}
           TextXY(520,212,'/1',15);
           TWC := Getnumber(60,14,4,15);
           if TWC = '' then TWC := '1.1';
           Val(TWC,WC,SubPNErr);
           ClsGr(331,201,609,249);
           TextXY(340,212,'��������������:',15);
           TextXY(500,212,'Second',15);
           TSamrate := Getnumber(57,14,3,15);
           if TSamrate = '' then TSamrate := '2';
           Val(TSamrate,SR,SubPNErr);
           GetDate(YY,MM,DD,Dow);
           Assign(FN,PSName);
           Rewrite(FN);
             FF.FWC := WC;
             FF.FY := YY;
             FF.FMN := MM;
             FF.FD := DD;
             FF.FProject := ProjectName;
             FF.Fbelong := Sbelong;
             FF.FWork := SWork;
             FF.FCCement := CCement;
             FF.SamRate := SR;
             FF.FCDepth := 50;
             FF.FCStroke := 200;
             FF.FCPress := 1000;
             FF.FCDrill := 20;
             FF.FCFlow := 2.365;
             FF.FCBat := 300;
           Write(FN,FF);
           Close(FN);
Outside:
End;

Procedure ChangeConst(Vari:Word);
Label Exit;
Var Selected : Word;
Begin
    Selected := Vari;
    Assign(FN,Project);
    Reset(FN);
    Seek(FN,0);
    Case Selected of
1:  Begin
      FF.FCCement := CSRatio;
      Write(FN,FF);
      Goto Exit;
    End;
2:  Begin
      FF.SamRate := Sampling;
      Write(FN,FF);
      Goto Exit;
    End;
3:  Begin
      FF.FCDepth := ConDepth;
      Write(FN,FF);
      Goto Exit;
    End;
4:  Begin
      FF.FCStroke := ConStroke;
      Write(FN,FF);
      Goto Exit;
    End;
5:  Begin
      FF.FCPress := ConPress;
      Write(FN,FF);
      Goto Exit;
    End;
6:  Begin
      FF.FCDrill := ConDrill;
      Write(FN,FF);
      Goto Exit;
    End;
7:  Begin
      FF.FCFlow := ConFlow;
      Write(FN,FF);
      Goto Exit;
    End;
8:  Begin
      FF.FCBat := ConBat;
      Write(FN,FF);
      Goto Exit;
    End;
9:  Begin
      FF.FWC := WCRatio;
      Write(FN,FF);
      Goto Exit;
    End;
10: Begin
      FF.Fbelong := Belong;
      Write(FN,FF);
      Goto Exit;
    End;
11: Begin
      FF.FWork := Work;
      Write(FN,FF);
      Goto Exit;
    End;
    End;{Case}
Exit:
    Close(FN);
End;

Procedure ChangeTimeDate;
label xs,xx,xz;
const
  days : array [0..6] of String[9] =
    ('Sunday','Monday','Tuesday',
     'Wednesday','Thursday','Friday',
     'Saturday');
var
  y, m, d, dow : Word;
  Date,TY,TM,TD : String;
  cde,DL : integer;
var
  h, mn, s, hund : Word;
function LeadingZero(w : Word) : String;
var
  s : String;
begin
  Str(w:0,s);
  if Length(s) = 1 then
    s := '0' + s;
  LeadingZero := s;
end;
begin
    RestoreCrtMode;
xs: clrscr;
    GetDate(y,m,d,dow);
    Writeln('Current Date is ', days[dow],', ',
          m:0, '/', d:0, '/', y:0);
    repeat
      writeln('Enter New Date (mm-dd-yyyy)');
      readln(Date);
      DL := Length(Date);
    until (DL = 10) or (Date = '');
    if Date = '' then goto xx;
    TY := copy(Date,7,4);
    Val(TY,y,cde);
    if cde <> 0 then goto xs;
    TM := copy(Date,1,2);
    Val(TM,m,cde);
    if cde <> 0 then goto xs;
    TD := copy(Date,4,2);
    Val(TD,d,cde);
    if cde <> 0 then goto xs;
    SetDate(y,m,d);
xx:
    clrscr;
    GetTime(h,mn,s,hund);
    Writeln('Current Time Is ',LeadingZero(h),':',
        LeadingZero(mn),':',LeadingZero(s),
        '.',LeadingZero(hund));
    repeat
      writeln('Enter New Time (hh-mm-ss)');
      readln(Time);
      DL := Length(Time);
    until (DL = 8) or (Time = '');
    if Time = '' then goto xz;
    TY := copy(Time,7,2);
    Val(TY,s,cde);
    if cde <> 0 then goto xx;
    TM := copy(Time,1,2);
    Val(TM,h,cde);
    if cde <> 0 then goto xx;
    TD := copy(Time,4,2);
    Val(TD,mn,cde);
    if cde <> 0 then goto xx;
    SetTime(h,mn,s,0);
xz: SetGraphMode(GraphMode);
end;

Function AnalogInput(DAT:String;Gp:Byte):Word;
var DataCount: Byte;
    DATA : Array[1..4] Of String[1];
    Adat: String;
    R0,R1,R2,cn: Integer;
    Data1,Data2,Data3,Data4: String[1];
begin
  AnalogInput := 0;
  cn := pos('>',DAT);
  Case Gp of
    1: Adat := copy(DAT,cn+1,4);
    2: Adat := copy(DAT,cn+6,4);
    3: Adat := copy(DAT,cn+11,4);
    4: Adat := copy(DAT,cn+16,4);
    5: Adat := copy(DAT,cn+21,4);
    6: Adat := copy(DAT,cn+26,4);
    7: Adat := copy(DAT,cn+31,4);
    8: Adat := copy(DAT,cn+36,4);
  end;
  For DataCount := 1 to 4 do
  begin
    Data[DataCount] := Copy(Adat,DataCount,1);
  end;
  Data1 := Data[1];
  Data2 := Data[2];
  Data3 := Data[3];
  Data4 := Data[4];
  if Data4 = '0' then R2 := 0
  else if Data4 = '1' then R2 := 1
  else if Data4 = '2' then R2 := 2
  else if Data4 = '3' then R2 := 3
  else if Data4 = '4' then R2 := 4
  else if Data4 = '5' then R2 := 5
  else if Data4 = '6' then R2 := 6
  else if Data4 = '7' then R2 := 7
  else if Data4 = '8' then R2 := 8
  else if Data4 = '9' then R2 := 9
  else if Data4 = 'A' then R2 := 10
  else if Data4 = 'B' then R2 := 11
  else if Data4 = 'C' then R2 := 12
  else if Data4 = 'D' then R2 := 13
  else if Data4 = 'E' then R2 := 14
  else if Data4 = 'F' then R2 := 15
  else R2 := 0;
  if Data3 = '0' then R1 := 0
  else if Data3 = '1' then R1 := 1
  else if Data3 = '2' then R1 := 2
  else if Data3 = '3' then R1 := 3
  else if Data3 = '4' then R1 := 4
  else if Data3 = '5' then R1 := 5
  else if Data3 = '6' then R1 := 6
  else if Data3 = '7' then R1 := 7
  else if Data3 = '8' then R1 := 8
  else if Data3 = '9' then R1 := 9
  else if Data3 = 'A' then R1 := 10
  else if Data3 = 'B' then R1 := 11
  else if Data3 = 'C' then R1 := 12
  else if Data3 = 'D' then R1 := 13
  else if Data3 = 'E' then R1 := 14
  else if Data3 = 'F' then R1 := 15
  else R1 := 0;
  if Data2 = '0' then R0 := 0
  else if Data2 = '1' then R0 := 1
  else if Data2 = '2' then R0 := 2
  else if Data2 = '3' then R0 := 3
  else if Data2 = '4' then R0 := 4
  else if Data2 = '5' then R0 := 5
  else if Data2 = '6' then R0 := 6
  else if Data2 = '7' then R0 := 7
  else if Data2 = '8' then R0 := 8
  else if Data2 = '9' then R0 := 9
  else if Data2 = 'A' then R0 := 10
  else if Data2 = 'B' then R0 := 11
  else if Data2 = 'C' then R0 := 12
  else if Data2 = 'D' then R0 := 13
  else if Data2 = 'E' then R0 := 14
  else if Data2 = 'F' then R0 := 15
  else R0 := 0;
  AnalogInput := R0*256+R1*16+R2;
end;

Function DigitalInput(DAT:String;DN: Byte):Boolean;
var Adat: String;
    cn: Integer;
begin
  DigitalInput := False;
  cn := pos('>',DAT);
  Case DN of
  1: Adat := Copy(DAT,cn+1,1);
  2: Adat := Copy(DAT,cn+2,1);
  3: Adat := Copy(DAT,cn+3,1);
  4: Adat := Copy(DAT,cn+4,1);
  end;
  if Adat = '1' then DigitalInput := True else DigitalInput := False;
end;


{***************************** MAIN PROGRAM ***********************}
var dss,Xss : LongInt;
    FName, Mname: PathStr;
    DptStr,DrlStr,Result,BatStr,AnalogStr1,AnalogStr2,DigitalStr : String;
    N,P,Xu,ik,NoPix,AStat,BStat,CStat,DStat,Tstat1,Tstat2: integer;
    MShow,kk,Txx,TIX,FirstGraph,RealPlotPrint,FirstPlotPrint:Boolean;
    ChangDpt,PrintColor,Comm2OK : Boolean;
    Scomm1,Scomm2,Scomm3,Scomm4 : word;
    C1,C2,C3,C4,cc,TI,PNN,lct,Dlengh: Integer;
    TCC,TC1,TC2,TC3,TC4,TCha,TCh1,TCh2,TBatV,TMixV,TSkwV,Sw,CTdat:String;
    IDChar,buff: Char;
    nl1,nl2,dptcnt,ddc: byte;
    mmm,nnn,lll,Ana: String;
    DptDrl : array[0..100] of Char;
    Buffer: Char;
    TT: Boolean;

Procedure WriteData(Sport:Byte;Word:String);
begin
  InstallInt(Sport);
  Set_DTR_RTS(Sport,True);
  delay(10);
  WriteCom(Sport,Word);
  Delay(5);
  Set_DTR_RTS(Sport,False);
  RemoveInt(Sport);
end;

procedure readDI;
begin
  Set_DTR_RTS(2,True);
  delay(5);
  TT := WriteCom(2,'#');
  TT := WriteCom(2,'0');
  TT := WriteCom(2,'2');
  TT := WriteCom(2,'R');
  TT := WriteCom(2,'D');
  TT := WriteCom(2,'I');
  TT := WriteCom(2,CHR(13));
  delay(2);
  Set_DTR_RTS(2,False);
  delay(2);
  N:=0;
  DigitalStr := '';
  repeat
    TT := TimedReadCom(2,Buffer);
    DigitalStr := DigitalStr + Buffer;
    N := N+1;
  until (Buffer = CHR(13)) or (N >= 10);
end;

procedure readAI;
begin
  Set_DTR_RTS(2,True);
  delay(5);
  TT := WriteCom(2,'#02RAI12');
  TT := WriteCom(2,CHR(13));  {'\r': 0x0D}
  delay(2);
  Set_DTR_RTS(2,False);
  delay(3);
  N:=0;
  AnalogStr1 := '';
  repeat
    TT := TimedReadCom(2,Buffer);
    AnalogStr1 := AnalogStr1 + Buffer;
    N := N+1;
  until (Buffer = CHR(13)) or (N >= 80);
end;

procedure readDpt;
begin
  Set_DTR_RTS(1,True);
  delay(5);
  TT := WriteCom(1,'#');
  TT := WriteCom(1,'0');
  TT := WriteCom(1,'0');
  TT := WriteCom(1,'R');
  TT := WriteCom(1,'A');
  delay(2);
  Set_DTR_RTS(1,False);
  delay(2);
  N:=0;
  DptStr := '';
  repeat
    TT := TimedReadCom(1,Buffer);
    DptStr := DptStr + Buffer;
    N := N+1;
  until (Buffer = CHR(13)) or (N >= 20);
end;

procedure readDrl;
begin
  Set_DTR_RTS(1,True);
  delay(5);
  TT := WriteCom(1,'#');
  TT := WriteCom(1,'0');
  TT := WriteCom(1,'0');
  TT := WriteCom(1,'R');
  TT := WriteCom(1,'B');
  delay(2);
  Set_DTR_RTS(1,False);
  delay(2);
  N:=0;
  DrlStr := '';
  repeat
    TT := TimedReadCom(1,Buffer);
    DrlStr := DrlStr + Buffer;
    N := N+1;
  until (Buffer = CHR(13)) or (N >= 20);
end;

Begin  {MAIN}
  SetupCOMPort(1,Ord (B9600),8,Ord (None),1);
  SetupCOMPort(2,Ord (B9600),8,Ord (None),1);
  N := 1;
  P := 1;
  Xu := 0;
  dss := 3;
  Fname := 'Z:\Temp.Grp';
  Mname := 'Z:\Temp.Pic';
  {Repeat
    dss := dss + 1;
    Xss := DiskSize(dss);
  until Xss <> -1;
  case dss of
   4 : begin
         Fname := 'D:\Temp.Grp';
         Mname := 'D:\Temp.Pic';
       end;
   5 : begin
         Fname := 'E:\Temp.Grp';
         Mname := 'E:\Temp.Pic';
       end;
   6 : begin
         Fname := 'F:\Temp.Grp';
         Mname := 'F:\Temp.Pic';
       end;
   7 : begin
         Fname := 'G:\Temp.Grp';
         Mname := 'G:\Temp.Pic';
       end;
   8 : begin
         Fname := 'H:\Temp.Grp';
         Mname := 'H:\Temp.Pic';
       end;
   9 : begin
         Fname := 'I:\Temp.Grp';
         Mname := 'I:\Temp.Pic';
       end;
   10: begin
         Fname := 'J:\Temp.Grp';
         Mname := 'J:\Temp.Pic';
       end;
  end;}
     InitialGraph;
     K := 495;
     ClsGr(0,0,GetMaxX,GetMaxY);
     SetTextStyle(2,0,5);
     TextXY(200,225,'Initailize USB Disk Please Wait !!',15);
     DrvStatus := ChDrv(4);
     delay(1000);
     ClsGr(69,179,551,286);
     ChDir('C:\Jet');
run:
     ProjConst;
     FixBV := 0;
     BV := 0;
     FixV1 := 0;
     CV1 := 0;
     JetStatus := False;
     RecCount := False;
     Xcode := 'Somchai';
     tick := ticktime;
     Dspeed := tick;
     Str(Sampling:4:1,TSampling);
     Sampling := Sampling * 17;
     CDspeed := 17;
     Beep := 5;
     RealPlot := False;
     FirstPlot := False;
     FirstGraph := True;
     RealPlotPrint := False;
     FirstPlotPrint := False;
     Mshow := False;
     no := 2;
     PNN := 1;
     Volume := 0;
     LogOn := 0;
     {Spt1 := 200; Spt2 := 0;lct := 0;
     InstallInt(1);
     Str(Spt1:4:1,SetPoint1);
     TConBat := SetPoint1;
     ConBat := Spt1;}
     ChangeConst(8);
     ChangDpt := False;
     ClsGr(0,0,GetMaxX,GetMaxY);
Rec:
     GetTime(STH,STM,STS,STSS);
     GetTime(WCH,WCM,WCS,WCSS);
     STT := STH*3600+STM*60+STS;
     Cement := 0;
     XCement := 0;
     RCH:=0;RCM:=0;RCM:=0;RCSS:=0;
     JetTime := 0;
Loop:
     Counter := 1;
     Response := 1;
     MaxBat := 0;
     MaxDepth := 0;
     PrintBat := False;
     OldDepth := 78;
First:
{---------------------------------------------------}
{****************Start Main Loop********************}
{---------------------------------------------------}
     Pressure := 0;
     Stroke := 0;
     ClsGr(0,0,GetMaxX,GetMaxY);
Second:
       PjN := Project;
       Delete(PjN, 1, 7);
       Dirtory := Project;
       Dlengh := Length(Dirtory);
       Delete(Dirtory,Dlengh-3,4);
       Dirtory := Dirtory+'\';
       SC := RealToStr(CSRatio);
       WCR := RealToStr(WCRatio);
       SP := RealToStr(Sampling);
       InstallInt(1);
       InstallInt(2);
     REPEAT
       readAI;
       readDpt;
       N := pos('.',DptStr);
       Result := copy(DptStr,N-3,6);
       Val(Result,Depth,err);
       readDI;
       readDrl;
       N := pos('.',DrlStr);
       Result := copy(DrlStr,N-2,4);
       Val(Result,Drill,err);
       MixValve := DigitalInput(DigitalStr,2);
       SkrewValve := DigitalInput(DigitalStr,3);
       Stroke := AnalogInput(AnalogStr1,1)*0.073;
       Pressure := AnalogInput(AnalogStr1,2)*0.17;
       If MixValve = True Then
       Begin
          SD := 6;
          GetTime(RCH,RCM,RCS,RCSS);
          JetTime := RCH*60-WCH*60+RCM-WCM
                    +RCS/60-WCS/60+RCSS/6000-WCSS/6000;
          GetTime(WCH,WCM,WCS,WCSS);
          XCement := Flow*CRate*JetTime;
          Cement := Cement + XCement;
       End
       Else
       Begin
          SD := 1;
          GetTime(WCH,WCM,WCS,WCSS);
       End;
{-----------------Time----------------------}
       GetTime(H,M,S,SS);
       If JetStatus = True Then
       Begin
         SCT := (H*3600+M*60+S)-STT;
         SCT := (H-STH)*3600+(M-STM)*60+(S-STS);
         SH := SCT Div 3600;
         SM := SCT Div 60;
         If SM < 60 then SM := SM;
         If SM >= 60 then SM := SM Mod 60;
         SSS := SCT;
         If SSS < 60 then SSS := SSS;
         If SSS >= 60 then SSS := SCT Mod 60;
       End
       Else
       Begin
         SCT := 0;
         SH := 0;
         SM := 0;
         SSS := 0;
       End;
       Str(H,TH);
       Str(M,TM);
       If M < 10 Then TM := '0' + TM;
       Str(S,TS);
       If S < 10 Then TS := '0' + TS;
       Str(SH,TSH);
       Str(SM,TSM);
       Str(SSS,TSS);
       If SSS < 10 Then TSS := '0'+TSS
       Else TSS := TSS;
       Time := TH+':'+TM+':'+TS;
       FBat := Bat;
       Str(ConDepth:5:2,TConDep);
       TConDepth := TConDep;
       Str(ConStroke:4:1,TConStroke);
       Str(ConPress:4:1,TConPress);
       Str(ConDrill:3:1,TConDrill);
       Str(ConBat:4:1,TConBat);
       Str(ConFlow:4:3,TConFlow);
       Str(WCRatio:3:2,TWC);
       CRate := 3.1/(WCRatio*3.1+1);
       Str(CRate:3:2,TCRate);
       Str(CSRatio:4:1,TCSRatio);
       Str(Cement:5:1,TCement);
       TConDep := TConDep+' M';
       Str(ConDepth/4:5:2,TConDepQ);
       TConDepQ := TConDepQ+' M';
       Str(ConDepth/2:5:2,TConDepH);
       TConDepH := TConDepH+' M';
       Str(ConDepth/2+ConDepth/4:5:2,TConDepHQ);
       TConDepHQ := TConDepHQ+' M';
       Depth := Depth;
       Stroke := Stroke;
       Flow := Stroke*ConFlow;
       Pressure := Pressure;
       Drill := Drill;
       If MaxBat <= Bat Then MaxBat := Bat;
       Volume := 0;
       GetDate(YY,MM,DD,DOW);
       Str(YY,TYY);
       TMM := EMonth(MM);
       Str(DD,TDD);
       Date := TMM+'/'+TDD+'/'+TYY;
       Str(Depth:5:2,TDepth);
       If MaxDepth <= Depth Then MaxDepth := Depth;
       Str(MaxDepth:5:2,TMaxDepth);
       Str(Stroke:4:1,TStroke);
       Str(Flow:4:1,TFlow);
       Str(Volume:4:1,TVolume);
       Str(Pressure:4:1,TPressure);
       Str(Drill:3:1,TDrill);
       {Str(Bat:4:1,TBat);
       TBat := TBat+' Kgs.';}
       if Depth > 0 then
         DoDepth := 78 + Round(Depth*288/ConDepth)
       else DoDepth := 78;
       if DoDepth >= 366 then DoDepth := 366;
       {if Bat > 0 then
         DoBat := Round(Bat*100/Spt1+1)
       else DoBat := 0;
       if DoBat > 100 then DoBat := 100;}
       If tick+Sampling < Ticktime then
       begin
         MShow := true;
         tick := ticktime;
       end;
       If JetStatus and Mshow then
       Begin
         JD.Project := PjN;
         JD.JTime := Time;
         JD.Slurry := MixValve;
         JD.JDate := Date;
         JD.JDepth := TDepth;
         JD.JStroke := TStroke;
         JD.JPress := TPressure;
         JD.JDrill := TDrill;
         JD.JFlow := TFlow;
         JD.JCement := TCement;
         Write(FJ,JD);
         if RealPlot  = False then
         begin
           Sound(4345);
           Delay(10);
           Sound(230);
           Delay(10);
           Nosound;
           MShow := False;
         end;
       End;
        If SkrewValve = True Then
          Begin
            CV1 := 7;
            FixV1 := CV1;
          End
        Else
          begin
            CV1 := 0;
          end;
    if ChangDpt then
    begin
      CShow := ShowHeader(Project,Column);
      ShowTime(Time,TSH,TSM,TSS);
      ShowDepth(TDepth);
      ShowFlowrate(TFlow);
      ShowPressure(TPressure);
      ShowDrill(TDrill);
      ShowDrillRotate(Drill,Counter);
      ShowCement(TCement);
      If JetStatus then ShowRecord
      else ClearRecord;
      ShowCorner;
      ShowDptForm(Date,ConDepth);
      ShowDrillColor(SD);
      ShowDepthPattern(Pressure,SD,OldDepth,DoDepth,TMaxDepth);
      ShowMixWaterValve(MixWaterV);
      ShowJetWaterTank(WaterV);
      ShowJetWaterCement(SD);
      ShowMixWaterTank(WLevelH,WLevelL);
      ShowMix(SD);
      If K >= 441 then K := K-27;
      If K < 441 Then K := 495;
      ShowPump(Stroke,TStroke,K,SD);
      ShowJetCement(MixValve,C4,C3,C2,C1,SD);
      ChangDpt := False;
      StoreImage(MName, 0, 0, GetMaxX, GetMaxY);
    end;
    if FirstGraph then FirstGraph := False {else RestoreImage(MName,0,NoPix)};
      CShow := ShowHeader(Project,Column);
      ShowTime(Time,TSH,TSM,TSS);
      ShowDepth(TDepth);
      ShowFlowrate(TFlow);
      ShowPressure(TPressure);
      ShowDrill(TDrill);
      ShowDrillRotate(Drill,Counter);
      ShowCement(TCement);
      If JetStatus then ShowRecord
      else ClearRecord;
      ShowCorner;
      ShowDptForm(Date,ConDepth);
      ShowDrillColor(SD);
      ShowDepthPattern(Pressure,SD,OldDepth,DoDepth,TMaxDepth);
      ShowMixWaterValve(MixWaterV);
      ShowJetWaterTank(WaterV);
      ShowJetWaterCement(SD);
      ShowMixWaterTank(WLevelH,WLevelL);
      ShowMix(SD);
      If K >= 441 then K := K-27;
      If K < 441 Then K := 495;
      ShowPump(Stroke,TStroke,K,SD);
      ShowJetCement(MixValve,C4,C3,C2,C1,SD);
      OldDepth := DoDepth;
    Counter := Counter + 1;
    If Counter = 4 then
    begin
      Counter := 1;
      DrvStatus := ChUSBDrv(4);
      DriveSpace(Dsize,FreeB);
    end;
    SetTextJustify(0,1);
    {OuttextXY(330,50,'Project='+Project);
    OuttextXY(330,60,'Column='+Column);
    OuttextXY(330,70,'Cshow='+Cshow);
    OuttextXY(330,80,'Pjn='+Pjn);
    OuttextXY(330,90,'Dirtory='+Dirtory);}
  UNTIL Keypressed;
{-----------------------------------------------------}
{******************End of Main Loop*******************}
{-----------------------------------------------------}
    StoreImage(MName, 0, 0, GetMaxX, GetMaxY);
    SetTextJustify(0,1);
    SetTextStyle(2,0,4);
    InChar := Upcase(ReadKey);
    If InChar = 'O' then
      Begin
        Rectangle(330,200,610,230);
        ClsGr(331,201,609,229);
        MoveTo(350,207);
        Outtext('Change Stroke Mul. From:');
        MoveTo(546,207);
        Outtext(TConFlow);
        MoveTo(434,224);
        Outtext('To:');
        SetViewPort(351,201,599,229,True);
        TConFlow := Getnumber(59,14,5,15);
        If TConFlow = '' then Goto Loop;
        Val(TConFlow,ConFlow,Err);
        ChangeConst(7);
        ChangDpt := True;
        Goto Loop;
      End
    Else If InChar = 'X' then
      Begin
        Rectangle(330,200,610,230);
        ClsGr(331,201,609,229);
        MoveTo(350,207);
        Outtext('Change Max Depth From:');
        MoveTo(546,207);
        Outtext(TConDepth);
        MoveTo(434,224);
        Outtext('To:');
        SetViewPort(351,201,599,229,True);
        TConDepth := Getnumber(59,14,4,15);
        If TConDepth = '' then Goto Loop;
        Val(TConDepth,ConDepth,Err);
        ChangeConst(3);
        ChangDpt := True;;
        Goto Loop;
      End
    Else If InChar = 'L' then
      Begin
        Rectangle(330,200,610,230);
        ClsGr(331,201,609,229);
        MoveTo(350,207);
        Outtext('Change Max Drill From:');
        MoveTo(546,207);
        Outtext(TConDrill);
        MoveTo(434,224);
        Outtext('To:');
        SetViewPort(351,201,599,229,True);
        TConDrill := Getnumber(59,14,4,15);
        If TConDrill = '' then Goto Loop;
        Val(TConDrill,ConDrill,Err);
        ChangeConst(6);
        ChangDpt := True;
        Goto Loop;
      End
    Else If InChar = 'J' then
      Begin
        Rectangle(330,200,610,230);
        ClsGr(331,201,609,229);
        MoveTo(340,207);
        Outtext('Change Project Name From:');
        MoveTo(540,207);
        Outtext(PShow);
        MoveTo(424,224);
        Outtext('To:');
        SetViewPort(351,201,599,229,True);
        Projec := ReadStr(57,14,8,'E',15);
        If Projec = '' then Goto Loop;
        Projec := 'C:\jet\'+projec+'.prj';
        ProjName(Projec);
        Goto run;
      End
    Else If InChar = 'E' then
      Begin
        Rectangle(330,200,610,230);
        ClsGr(331,201,609,229);
        MoveTo(350,207);
        Outtext('Change Max Pressure From:');
        MoveTo(550,207);
        Outtext(TConPress);
        MoveTo(434,224);
        Outtext('To:');
        SetViewPort(351,201,599,229,True);
        TConPress := Getnumber(59,14,5,15);
        If TConPress = '' then Goto Loop;
        Val(TConPress,ConPress,Err);
        ChangeConst(5);
        ChangDpt := True;
        Goto Loop;
      End
    Else If InChar = 'S' then
      Begin
        Rectangle(330,200,610,230);
        ClsGr(331,201,609,229);
        MoveTo(350,207);
        Outtext('Change Sampling From:');
        MoveTo(526,207);
        Outtext(TSampling);
        MoveTo(565,207);
        Outtext('Sec');
        MoveTo(434,224);
        Outtext('To:');
        SetViewPort(351,201,599,229,True);
        TTSam := Getnumber(59,14,4,15);
        If TTSam = '' then Goto Loop;
        Val(TTSam,Sampling,Err);
        ChangeConst(2);
        TSampling := TTSam;
        Sampling := Sampling * 17;
        Goto Loop;
      End
    Else If InChar = 'F' Then
      Begin
        Rectangle(330,200,610,230);
        ClsGr(331,201,609,229);
        MoveTo(350,207);
        Outtext('Change Max Stroke From:');
        MoveTo(546,207);
        Outtext(TConStroke);
        MoveTo(434,224);
        Outtext('To:');
        SetViewPort(351,201,599,229,True);
        TConStroke := Getnumber(59,14,5,15);
        If TConStroke = '' then Goto Loop;
        Val(TConStroke,ConStroke,Err);
        ChangeConst(4);
      Goto Loop;
    End
    Else If InChar = 'W' Then
      Begin
        Rectangle(330,200,610,230);
        ClsGr(331,201,609,229);
        MoveTo(365,207);
        Outtext('Change W/C From:');
        MoveTo(526,207);
        Outtext(TWC);
        MoveTo(560,207);
        Outtext('/1');
        MoveTo(424,224);
        Outtext('To:');
        MoveTo(500,224);
        OutText('/1');
        SetViewPort(351,201,599,229,True);
        TWC := Getnumber(58,14,4,15);
        If TWC = '' then Goto Loop;
        Val(TWC,WCRatio,Err);
        ChangeConst(9);
      Goto Loop;
    End
    Else If InChar = 'I' then
      Begin
        Rectangle(320,200,620,230);
        ClsGr(321,201,619,229);
        MoveTo(324,207);
        Outtext('Change Cement/Soil From:');
        MoveTo(518,207);
        Outtext(TCSRatio);
        MoveTo(564,207);
        Outtext('Kgs/QM');
        MoveTo(404,224);
        Outtext('To:');
        MoveTo(490,224);
        OutText('Kgs/QM');
        SetViewPort(351,201,599,229,True);
        TCSRatio := Getnumber(56,14,5,15);
        If TCSRatio = '' then Goto Loop;
        Val(TCSRatio,CSRatio,Err);
        ChangeConst(1);
      Goto Loop;
    End
    Else If InChar = 'Q' Then
      Begin
        Rectangle(330,205,610,235);
        ClsGr(331,206,609,234);
        textXY(350,212,'�ô��͹���ʼ�ҹ:',15);
        SetViewPort(351,206,599,234,True);
        SecCode := ReadXtr(60,14,8,'E',15);
        If Xcode = SecCode then Goto TheEnd
        Else Goto Loop;
      End
    Else If InChar = 'T' then
      begin
        ChangeTimeDate;
        RestoreImage(MName,0,NoPix);
        goto Second;
      end
    Else If InChar = 'C' then
      Begin
        CreatJet;
        If RecCount = True then Goto Loop;
        If RecCount = False then
        begin
          ChangDpt := True;
          Goto Rec;
        end;
      End
    Else If InChar = 'R' then
      Begin
        If JetStatus = False then
        Begin
          If RecCount = False then
          Begin
            If Column <> '' then
            Begin
              Assign(FJ,Column);
              Rewrite(FJ);
              JetStatus := True;
              RecCount := True;
              if Realplot = False then Goto Rec
              else
                begin
                  GetTime(STH,STM,STS,STSS);
                  GetTime(WCH,WCM,WCS,WCSS);
                  STT := STH*3600+STM*60+STS;
                  Cement := 0;
                  XCement := 0;
                  RCH:=0;RCM:=0;RCM:=0;RCSS:=0;
                  JetTime := 0;
                  Counter := 1;
                  Response := 1;
                  MaxBat := 0;
                  MaxDepth := 0;
                  PrintBat := False;
                  OldDepth := 78;
                  RestoreImage(MName,0,NoPix);
                  goto Second;
                end;
            End
            Else
            Begin
              Repeat
                Rectangle(330,200,610,260);
                ClsGr(331,201,609,259);
                textXY(416,210,'�ѧ������駪������!',15);
                textXY(380,234,'(�� ENTER ���ͷӧҹ����)',15);
                Delay(500);
                ClsGr(331,201,609,259);
                Delay(500);
              Until Keypressed;
              RecCount := False;
              if Realplot = False then Goto Loop
              else
                begin
                  Counter := 1;
                  Response := 1;
                  MaxBat := 0;
                  MaxDepth := 0;
                  PrintBat := False;
                  OldDepth := 78;
                  RestoreImage(MName,0,NoPix);
                  goto Second;
                end;
            End;
          End
        Else
        Begin
          SetViewPort(330,200,610,260,True);
          ClsGr(331,200,609,259);
          Rectangle(330,200,610,260);
          MoveTo(365,210);
          Outtext('This Column Already Exist');
          Moveto(375,230);
          OutText('Work with this Column?');
          Moveto(365,250);
          OutText('Press Y if ok N if not ok!');
          Repeat
            InChar := Upcase(ReadKey);
            If InChar = 'N' then
            Begin
              RecCount := False;
              GoTo Loop;
            End;
          Until InChar = 'Y';
          Assign(FJ,Column);
          Reset(FJ);
          seek(FJ,Filesize(FJ));
            JetStatus := True;
            RecCount := True;
              if Realplot = False then Goto Loop
              else
                begin
                  Counter := 1;
                  Response := 1;
                  MaxBat := 0;
                  MaxDepth := 0;
                  PrintBat := False;
                  OldDepth := 78;
                  RestoreImage(MName,0,NoPix);
                  goto Second;
                end;
        End;
        End
        Else
        Begin
          Close(FJ);
          If DrvStatus then CreatDJet(Column,CShow);
          JetStatus := False;
          ClsGR(600,300,620,310);
          if Realplot = False then Goto Loop
          else
            begin
              Counter := 1;
              Response := 1;
              MaxBat := 0;
              MaxDepth := 0;
              PrintBat := False;
              OldDepth := 78;
              RestoreImage(MName,0,NoPix);
              goto Second;
            end;
        End;
      End
    Else If InChar = 'P' then
PAgain:
      Begin
          Rectangle(450,220,500,230);
          SetTextJustify(0,1);
          {SetTextStyle(0,0,1);}
          setColor(15);
          Repeat
            ClsGr(451,221,499,229);
            Delay(500);
            MoveTo(456,226);
            Outtext('PAUSE');
            Delay(500);
            GetTime(WCH,WCM,WCS,WCSS);
          Until Keypressed;
          InChar := Upcase(Readkey);
          If InChar = Char(80) Then
          Begin
            ClsGr(450,220,500,230);
            RestoreImage(MName,0,NoPix);
            Goto Second;
          End
          Else Goto PAgain;
      End
    Else If InChar = '?' then
      begin
        ClsGr(0,0,GetMaxX,GetMaxY);
        SetColor(15);
        Rectangle(1,1,GetMaxX-1,GetMaxY-1);
        SetColor(1);
        bar(2,2,GetMaxX-2,GetMaxY-2);
        TextXY(20,20,'������ J = ��駪����ç���(!! ��ͧ�������ѧ��� !!)',15);
        TextXY(20,45,'������ C = ��駪������(!! ��ͧ�������ѧ��� !!)',15);
        TextXY(20,70,'������ X = ��駤����֡�٧�ش������(˹���������)',15);
        TextXY(20,95,'������ F = ��駻���ҵâͧ������(˹������Ե�)',15);
        TextXY(20,120,'������ E = ��駤���ç�ѹ�٧�ش(˹����� BAR)',15);
        TextXY(20,145,'������ L = ��駤�Ҥ��������ͺ�٧�ش�ͧ������(˹����� �ͺ/�ҷ�)',15);
        TextXY(20,170,'������ O = ��駤�Ҥ��������ͺ�٧�ش�ͧ������(˹����� �ͺ/�ҷ�)',15);
        TextXY(20,195,'������ T = ������� �ѹ ��͹ �� �ͧ����ͧ',15);
     {   TextXY(20,220,'������ Ctrl ������Ѻ���� V = ��駹��˹ѡ�٧�ش�ͧ�ٹ� Batch (�.�.) ���ͤǺ������ Screw �ٹ',15);}
        TextXY(20,220,'������ W = ��駤���ѵ����ǹ W/C',15);
     {   TextXY(20,270,'������ Ctrl ������Ѻ���� X = �������§ҹ�����ٹ�ͧ�ѹ���Ѩ�غѹ',15);}
        TextXY(20,245,'������ S = ����ѵ�ҡ������������ (����/�Թҷ�)',15);
{        TextXY(20,320,'������ Ctrl ������Ѻ���� Z >> ������ A �������§ҹ�����ٹ�������ͧ�ç���',15);
        TextXY(20,345,'������ Ctrl ������Ѻ���� Z >> ������ B ���͡�����2��§ҹ�����ٹ੾���ѹ',15);}
        TextXY(20,270,'������ R = �ѹ�֡������ (������ R �ա���� = ��ش�ѹ�֡������)',15);
        TextXY(20,295,'������ P = ��ش�ѹ�֡�����Ū��Ǥ��� (������ P �֡���� = �ѹ�֡���)',15);
        TextXY(20,320,'������ D = Duplicate File From Drive C to Flash Drive',15);
        TextXY(180,455,'������ ENTER ���͡�Ѻ�������÷ӧҹ����',10);
        Readln;
        ClsGr(0,0,GetMaxX,GetMaxY);
        RestoreImage(MName,0,NoPix);
        Goto First;
      end
    Else If InChar = 'D' then
      begin
        GoToCRTMode;
        nnn := Project;
        STCount := Length(nnn);
        Delete(nnn,STCount-3,5);
        lll := nnn;
        nnn := nnn + '\*.dat';
        mmm := CopyFile(nnn);
        lll := lll + '\' + mmm;
        STCount := Length(mmm);
        Delete(mmm,STCount-3,5);
        GoToGraphMode;
        CreatDJet(lll,mmm);
        RestoreImage(MName,0,NoPix);
        goto Second;
      end
    Else
    begin
     RestoreImage(MName,0,NoPix);
    Goto Second;
    end;
TheEnd:
    RemoveInt(1);
    RemoveInt(2);
    ClearDevice;
    Closegraph;
END.

