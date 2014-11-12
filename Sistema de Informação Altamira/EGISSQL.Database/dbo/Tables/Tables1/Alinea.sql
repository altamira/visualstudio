CREATE TABLE [dbo].[Alinea] (
    [cd_alinea]       INT          NOT NULL,
    [nm_alinea]       VARCHAR (40) NULL,
    [sg_alinea]       CHAR (10)    NULL,
    [cd_alinea_banco] INT          NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Alinea] PRIMARY KEY CLUSTERED ([cd_alinea] ASC) WITH (FILLFACTOR = 90)
);

