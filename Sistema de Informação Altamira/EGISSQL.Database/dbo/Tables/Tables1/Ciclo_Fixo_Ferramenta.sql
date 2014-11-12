CREATE TABLE [dbo].[Ciclo_Fixo_Ferramenta] (
    [cd_ciclo_fixo_ferramenta]  INT          NOT NULL,
    [nm_ciclo_fixo_ferramenta]  VARCHAR (30) NOT NULL,
    [sg_ciclo_fixo_ferramentas] CHAR (10)    NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Ciclo_Fixo_Ferramenta] PRIMARY KEY CLUSTERED ([cd_ciclo_fixo_ferramenta] ASC) WITH (FILLFACTOR = 90)
);

