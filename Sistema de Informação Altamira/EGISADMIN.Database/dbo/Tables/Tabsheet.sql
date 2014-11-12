CREATE TABLE [dbo].[Tabsheet] (
    [cd_tabsheet]       INT          NOT NULL,
    [nm_tabsheet]       VARCHAR (40) NULL,
    [nm_label_tabsheet] VARCHAR (40) NOT NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tabsheet] PRIMARY KEY CLUSTERED ([cd_tabsheet] ASC) WITH (FILLFACTOR = 90)
);

