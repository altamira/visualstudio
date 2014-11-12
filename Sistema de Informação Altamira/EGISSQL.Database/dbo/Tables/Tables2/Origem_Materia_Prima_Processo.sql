CREATE TABLE [dbo].[Origem_Materia_Prima_Processo] (
    [cd_origem_materia_prima]   INT          NOT NULL,
    [nm_origem_materia_prima]   VARCHAR (40) NULL,
    [sg_origem_materia_prima]   CHAR (10)    NULL,
    [ic_medida_fresa_ficha_med] CHAR (1)     NULL,
    [ic_consumo_meteria_prima]  CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Origem_Materia_Prima_Processo] PRIMARY KEY CLUSTERED ([cd_origem_materia_prima] ASC) WITH (FILLFACTOR = 90)
);

