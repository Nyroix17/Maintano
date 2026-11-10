unit dlg_formulaire6;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls, Spin;

type

  { TDlgFormulaire6 }

  TDlgFormulaire6 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    description: TMemo;
    duree: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    nom: TEdit;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel9: TPanel;
  private

  public
        idPDC : Integer;
  end;

var
  DlgFormulaire6: TDlgFormulaire6;

implementation

{$R *.lfm}

end.

