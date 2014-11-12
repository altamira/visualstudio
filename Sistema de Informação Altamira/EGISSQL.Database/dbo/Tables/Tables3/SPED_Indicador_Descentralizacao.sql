CREATE TABLE [dbo].[SPED_Indicador_Descentralizacao] (
    [cd_indicador_d] INT          NOT NULL,
    [nm_indicador]   VARCHAR (40) NULL,
    [sg_indicador]   CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_SPED_Indicador_Descentralizacao] PRIMARY KEY CLUSTERED ([cd_indicador_d] ASC)
);

