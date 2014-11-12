CREATE TABLE [dbo].[Motivo_Fechamento_Consulta] (
    [cd_motivo_fec_consulta] INT          NOT NULL,
    [nm_motivo_fec_consulta] VARCHAR (40) NULL,
    [sg_motivo_fec_consulta] CHAR (10)    NULL,
    [ic_padrao_motivo_fec]   CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Fechamento_Consulta] PRIMARY KEY CLUSTERED ([cd_motivo_fec_consulta] ASC) WITH (FILLFACTOR = 90)
);

