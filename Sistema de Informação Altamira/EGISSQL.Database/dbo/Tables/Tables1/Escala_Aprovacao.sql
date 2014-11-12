CREATE TABLE [dbo].[Escala_Aprovacao] (
    [cd_escala]          INT          NOT NULL,
    [cd_tipo_assinatura] INT          NOT NULL,
    [cd_tipo_aprovacao]  INT          NOT NULL,
    [vl_inicio_escala]   FLOAT (53)   NULL,
    [vl_final_escala]    FLOAT (53)   NULL,
    [nm_obs_escala]      VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Escala_Aprovacao] PRIMARY KEY CLUSTERED ([cd_escala] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Escala_Aprovacao_Tipo_Aprovacao] FOREIGN KEY ([cd_tipo_aprovacao]) REFERENCES [dbo].[Tipo_Aprovacao] ([cd_tipo_aprovacao])
);

