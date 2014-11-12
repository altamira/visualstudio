CREATE TABLE [dbo].[Registro_Recusa_Proposta] (
    [cd_registro_recusa]         INT          NOT NULL,
    [dt_registro_recusa]         DATETIME     NULL,
    [cd_consulta]                INT          NULL,
    [cd_item_consulta]           INT          NULL,
    [cd_motivo_recusa_consulta]  INT          NULL,
    [nm_obs_reg_recusa_consulta] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Registro_Recusa_Proposta] PRIMARY KEY CLUSTERED ([cd_registro_recusa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Recusa_Proposta_Motivo_Recusa_Consulta] FOREIGN KEY ([cd_motivo_recusa_consulta]) REFERENCES [dbo].[Motivo_Recusa_Consulta] ([cd_motivo_recusa_consulta])
);

