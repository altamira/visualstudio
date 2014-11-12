CREATE TABLE [dbo].[Sintegra_Status_Envio] (
    [cd_status_envio] INT          NOT NULL,
    [nm_status_envio] VARCHAR (40) NULL,
    [sg_status_envio] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Sintegra_Status_Envio] PRIMARY KEY CLUSTERED ([cd_status_envio] ASC) WITH (FILLFACTOR = 90)
);

