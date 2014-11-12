CREATE TABLE [dbo].[Demonstrativo_Lucro_Prejuizo] (
    [cd_demonstrativo] INT      NOT NULL,
    [cd_usuario]       INT      NULL,
    [dt_usuario]       DATETIME NULL,
    CONSTRAINT [PK_Demonstrativo_Lucro_Prejuizo] PRIMARY KEY CLUSTERED ([cd_demonstrativo] ASC) WITH (FILLFACTOR = 90)
);

