CREATE TABLE [dbo].[Caracteristica_Amostra] (
    [cd_caracteristica_amostra]   INT          NOT NULL,
    [nm_caracteristica_amostra]   VARCHAR (50) NULL,
    [sg_caracteristica_amostra]   CHAR (10)    NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [ic_tipo_dado_caracteristica] CHAR (1)     NULL,
    CONSTRAINT [PK_Caracteristica_Amostra] PRIMARY KEY CLUSTERED ([cd_caracteristica_amostra] ASC) WITH (FILLFACTOR = 90)
);

