CREATE TABLE [dbo].[Tipo_Calculo_Evento] (
    [cd_tipo_calculo_evento] INT          NOT NULL,
    [nm_tipo_calculo_evento] VARCHAR (40) NOT NULL,
    [sg_tipo_calculo_evento] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Calculo_Evento] PRIMARY KEY CLUSTERED ([cd_tipo_calculo_evento] ASC) WITH (FILLFACTOR = 90)
);

