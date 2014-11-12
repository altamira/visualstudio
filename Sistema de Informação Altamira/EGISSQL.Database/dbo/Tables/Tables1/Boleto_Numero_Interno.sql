CREATE TABLE [dbo].[Boleto_Numero_Interno] (
    [cd_boleto_numero_interno] INT      NOT NULL,
    [cd_conta_banco]           INT      NULL,
    [cd_nosso_numero_boleto]   INT      NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Boleto_Numero_Interno] PRIMARY KEY CLUSTERED ([cd_boleto_numero_interno] ASC) WITH (FILLFACTOR = 90)
);

