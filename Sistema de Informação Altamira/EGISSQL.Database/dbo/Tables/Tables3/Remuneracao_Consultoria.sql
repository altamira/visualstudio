CREATE TABLE [dbo].[Remuneracao_Consultoria] (
    [cd_remuneracao]          INT          NOT NULL,
    [nm_remuneracao]          VARCHAR (50) NULL,
    [nm_fantasia_remuneracao] VARCHAR (15) NULL,
    [sg_remuneracao]          CHAR (10)    NULL,
    [vl_remuneracao]          FLOAT (53)   NULL,
    [cd_unidade_medida]       INT          NULL,
    [nm_obs_remuneracao]      VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Remuneracao_Consultoria] PRIMARY KEY CLUSTERED ([cd_remuneracao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Remuneracao_Consultoria_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

