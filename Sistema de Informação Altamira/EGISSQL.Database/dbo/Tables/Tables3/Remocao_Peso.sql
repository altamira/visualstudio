CREATE TABLE [dbo].[Remocao_Peso] (
    [cd_remocao_peso]         INT          NOT NULL,
    [cd_remocao]              INT          NOT NULL,
    [qt_peso_inicial_remocao] FLOAT (53)   NULL,
    [qt_peso_final_remocao]   FLOAT (53)   NULL,
    [vl_remocao_peso]         FLOAT (53)   NULL,
    [nm_obs_remocao_peso]     VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Remocao_Peso] PRIMARY KEY CLUSTERED ([cd_remocao_peso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Remocao_Peso_Remocao] FOREIGN KEY ([cd_remocao]) REFERENCES [dbo].[Remocao] ([cd_remocao])
);

