CREATE TABLE [dbo].[Tipo_Evento] (
    [cd_tipo_evento]  INT          NOT NULL,
    [nm_tipo_evento]  VARCHAR (30) NOT NULL,
    [sg_tipo_evento]  CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    [ic_base_calculo] CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Evento] PRIMARY KEY CLUSTERED ([cd_tipo_evento] ASC) WITH (FILLFACTOR = 90)
);

