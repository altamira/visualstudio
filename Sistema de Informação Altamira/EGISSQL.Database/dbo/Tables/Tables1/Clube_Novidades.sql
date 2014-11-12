CREATE TABLE [dbo].[Clube_Novidades] (
    [cd_novidade] INT          NOT NULL,
    [nm_novidade] VARCHAR (60) NULL,
    [ds_novidade] TEXT         NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Clube_Novidades] PRIMARY KEY CLUSTERED ([cd_novidade] ASC)
);

