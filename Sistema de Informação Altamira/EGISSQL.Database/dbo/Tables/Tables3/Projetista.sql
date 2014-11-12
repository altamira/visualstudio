CREATE TABLE [dbo].[Projetista] (
    [cd_projetista]          INT          NOT NULL,
    [nm_projetista]          VARCHAR (30) NOT NULL,
    [nm_fantasia_projetista] VARCHAR (15) NOT NULL,
    [ic_status_projetista]   CHAR (1)     NOT NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_tipo_projetista]     INT          NOT NULL,
    [ic_libera_projeto]      CHAR (1)     NULL,
    [vl_hora_projetista]     FLOAT (53)   NULL,
    CONSTRAINT [PK_Projetista] PRIMARY KEY NONCLUSTERED ([cd_projetista] ASC) WITH (FILLFACTOR = 90)
);

