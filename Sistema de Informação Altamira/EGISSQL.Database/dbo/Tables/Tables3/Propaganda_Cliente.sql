CREATE TABLE [dbo].[Propaganda_Cliente] (
    [cd_propaganda]         INT      NOT NULL,
    [cd_cliente]            INT      NOT NULL,
    [ds_propaganda_cliente] TEXT     COLLATE Latin1_General_CI_AS NULL,
    [cd_usuario]            INT      NOT NULL,
    [dt_usuario]            DATETIME NOT NULL,
    CONSTRAINT [PK_Propaganda_Cliente] PRIMARY KEY CLUSTERED ([cd_propaganda] ASC, [cd_cliente] ASC) WITH (FILLFACTOR = 90)
);

