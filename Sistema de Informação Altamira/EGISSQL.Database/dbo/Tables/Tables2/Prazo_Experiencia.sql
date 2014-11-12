CREATE TABLE [dbo].[Prazo_Experiencia] (
    [cd_prazo_experiencia]      INT          NOT NULL,
    [nm_prazo_experiencia]      VARCHAR (40) NULL,
    [sg_prazo_experiencia]      CHAR (10)    NULL,
    [ic_pad_prazo_experiencia]  CHAR (1)     NULL,
    [ic_cont_prazo_experiencia] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Prazo_Experiencia] PRIMARY KEY CLUSTERED ([cd_prazo_experiencia] ASC) WITH (FILLFACTOR = 90)
);

