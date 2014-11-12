CREATE TABLE [dbo].[Registro_Fechamento_Consulta] (
    [cd_registro_fec_consulta] INT          NOT NULL,
    [dt_registro_fec_consulta] DATETIME     NULL,
    [cd_consulta]              INT          NULL,
    [cd_item_consulta]         INT          NULL,
    [cd_motivo_fec_consulta]   INT          NULL,
    [nm_obs_reg_fec_consulta]  VARCHAR (40) NULL,
    CONSTRAINT [PK_Registro_Fechamento_Consulta] PRIMARY KEY CLUSTERED ([cd_registro_fec_consulta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Fechamento_Consulta_Motivo_Fechamento_Consulta] FOREIGN KEY ([cd_motivo_fec_consulta]) REFERENCES [dbo].[Motivo_Fechamento_Consulta] ([cd_motivo_fec_consulta])
);

