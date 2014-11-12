CREATE TABLE [dbo].[Sintegra_Status_Retorno] (
    [cd_status_retorno] INT          NOT NULL,
    [nm_status_retorno] VARCHAR (40) NULL,
    [sg_status_retorno] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Sintegra_Status_Retorno] PRIMARY KEY CLUSTERED ([cd_status_retorno] ASC) WITH (FILLFACTOR = 90)
);

