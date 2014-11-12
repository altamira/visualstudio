CREATE TABLE [dbo].[Historico_Materia_Prima] (
    [cd_ciclo_fixo_ferramenta]  INT          NOT NULL,
    [nm_ciclo_fixo_ferramenta]  VARCHAR (30) NOT NULL,
    [sg_ciclo_fixo_ferramentas] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Historico_Materia_Prima] PRIMARY KEY CLUSTERED ([cd_ciclo_fixo_ferramenta] ASC) WITH (FILLFACTOR = 90)
);

