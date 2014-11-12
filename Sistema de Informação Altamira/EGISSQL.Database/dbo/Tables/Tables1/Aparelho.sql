CREATE TABLE [dbo].[Aparelho] (
    [cd_aparelho]               INT          NOT NULL,
    [nm_aparelho]               VARCHAR (40) NULL,
    [sg_aparelho]               CHAR (10)    NULL,
    [nm_fantasia_aparelho]      VARCHAR (15) NULL,
    [cd_identificacao_aparelho] VARCHAR (15) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Aparelho] PRIMARY KEY CLUSTERED ([cd_aparelho] ASC) WITH (FILLFACTOR = 90)
);

