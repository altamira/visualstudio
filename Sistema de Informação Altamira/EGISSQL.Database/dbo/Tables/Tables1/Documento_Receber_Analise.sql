CREATE TABLE [dbo].[Documento_Receber_Analise] (
    [cd_documento_receber]   INT          NOT NULL,
    [dt_analise_documento]   DATETIME     NULL,
    [cd_portador]            INT          NULL,
    [ic_analise_banco]       CHAR (1)     NULL,
    [ic_documento_rejeitado] CHAR (1)     NULL,
    [nm_obs_documento]       VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_documento_aprovado]  CHAR (1)     NULL,
    CONSTRAINT [PK_Documento_Receber_Analise] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC) WITH (FILLFACTOR = 90)
);

