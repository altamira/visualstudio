CREATE TABLE [dbo].[Inflacao] (
    [cd_inflacao] INT        NOT NULL,
    [dt_inflacao] DATETIME   NULL,
    [aa_inflacao] INT        NULL,
    [mm_inflacao] INT        NULL,
    [pc_inflacao] FLOAT (53) NULL,
    [cd_usuario]  INT        NULL,
    [dt_usuario]  DATETIME   NULL,
    CONSTRAINT [PK_Inflacao] PRIMARY KEY CLUSTERED ([cd_inflacao] ASC) WITH (FILLFACTOR = 90)
);

