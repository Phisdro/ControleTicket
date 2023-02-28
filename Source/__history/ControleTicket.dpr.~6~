program ControleTicket;

uses
  Vcl.Forms,
  UControleTicket in 'UControleTicket.pas' {frmControleTicket},
  UDMControleTicket in 'UDMControleTicket.pas' {DMControle: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmControleTicket, frmControleTicket);
  Application.CreateForm(TDMControle, DMControle);
  Application.Run;
end.
