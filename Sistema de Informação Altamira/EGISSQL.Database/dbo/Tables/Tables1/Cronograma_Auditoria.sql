CREATE TABLE [dbo].[Cronograma_Auditoria] (
    [dt_auditoria]        DATETIME     NOT NULL,
    [cd_item_auditoria]   INT          NOT NULL,
    [cd_topico_Auditoria] INT          NULL,
    [dt_inicio_auditoria] DATETIME     NULL,
    [dt_final_auditoria]  DATETIME     NULL,
    [hr_inicio_auditoria] VARCHAR (8)  NULL,
    [hr_final_auditoria]  VARCHAR (8)  NULL,
    [cd_auditor]          INT          NULL,
    [nm_obs_cronograma]   VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Cronograma_Auditoria] PRIMARY KEY CLUSTERED ([dt_auditoria] ASC, [cd_item_auditoria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cronograma_Auditoria_Auditor] FOREIGN KEY ([cd_auditor]) REFERENCES [dbo].[Auditor] ([cd_auditor])
);

