CREATE TABLE [dbo].[rb_item] (
    [item_id]   INT          IDENTITY (1, 1) NOT NULL,
    [folder_id] INT          NOT NULL,
    [item_name] VARCHAR (60) NOT NULL,
    [item_size] INT          NULL,
    [item_type] INT          NOT NULL,
    [modified]  FLOAT (53)   NOT NULL,
    [deleted]   FLOAT (53)   NULL,
    [template]  IMAGE        NULL,
    PRIMARY KEY CLUSTERED ([folder_id] ASC, [item_type] ASC, [item_name] ASC, [modified] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [item_id_idx]
    ON [dbo].[rb_item]([item_id] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [folder_item_name_idx]
    ON [dbo].[rb_item]([folder_id] ASC, [item_type] ASC, [item_name] ASC) WITH (FILLFACTOR = 90);

