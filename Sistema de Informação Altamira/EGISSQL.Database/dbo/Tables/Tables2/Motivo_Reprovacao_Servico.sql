CREATE TABLE [dbo].[Motivo_Reprovacao_Servico] (
    [cd_motivo_reprov_servico] INT          NOT NULL,
    [nm_motivo_reprov_servico] VARCHAR (40) NULL,
    [sg_motivo_repr_servico]   CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Reprovacao_Servico] PRIMARY KEY CLUSTERED ([cd_motivo_reprov_servico] ASC) WITH (FILLFACTOR = 90)
);

