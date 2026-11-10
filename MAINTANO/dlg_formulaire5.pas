unit dlg_formulaire5;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls, Spin;

type

  { TDlgFormulaire5 }

  TDlgFormulaire5 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    couleur: TEdit;
    Photo: TImage;
    Immat: TEdit;
    kilometrage: TFloatSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    marque: TEdit;
    modele: TEdit;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel9: TPanel;
    Poids: TEdit;
  private

  public
        idVehicule : Integer;
        NomPhoto : String;
        procedure ChargerImage(const NomFichier : String);
  end;

var
  DlgFormulaire5: TDlgFormulaire5;

implementation

{$R *.lfm}

procedure TDlgFormulaire5.ChargerImage(
  const NomFichier: string
);
begin
  Photo.Picture.Clear;

  if Trim(NomFichier) = '' then
    Exit;

  if FileExists(
    IncludeTrailingPathDelimiter(
      ExtractFilePath(Application.ExeName)
    ) +
    'photos\' +
    NomFichier
  ) then
  begin
    Photo.Picture.LoadFromFile(
      IncludeTrailingPathDelimiter(
        ExtractFilePath(Application.ExeName)
      ) +
      'photos\' +
      NomFichier
    );
  end;
end;

end.

