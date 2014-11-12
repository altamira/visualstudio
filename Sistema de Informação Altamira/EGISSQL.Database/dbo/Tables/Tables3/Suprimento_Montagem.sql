CREATE TABLE [dbo].[Suprimento_Montagem] (
    [cd_suprimento_montagem] INT      NOT NULL,
    [dt_suprimento_montagem] DATETIME NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_Suprimento_Montagem] PRIMARY KEY CLUSTERED ([cd_suprimento_montagem] ASC) WITH (FILLFACTOR = 90)
);

