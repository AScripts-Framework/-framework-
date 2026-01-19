-- ====================================
-- ox_inventory Item Definitions
-- ====================================
-- Add these to your ox_inventory/data/items.lua file:


-- POLICE EQUIPMENT
['handcuffs'] = {
    label = 'Handcuffs',
    weight = 200,
    stack = false,
    close = true,
    description = 'Police handcuffs for restraining suspects',
},

['radio'] = {
    label = 'Police Radio',
    weight = 300,
    stack = false,
    close = true,
    description = 'Police communication radio',
},

['police_stormram'] = {
    label = 'Battering Ram',
    weight = 5000,
    stack = false,
    close = true,
    description = 'Heavy duty door breaching tool',
},

['spikestrip'] = {
    label = 'Spike Strip',
    weight = 2000,
    stack = true,
    close = true,
    description = 'Deploy to stop fleeing vehicles',
},

['evidence_bag'] = {
    label = 'Evidence Bag',
    weight = 50,
    stack = true,
    close = true,
    description = 'Bag for collecting crime scene evidence',
},

-- EVIDENCE ITEMS
['evidence_bullet_casing'] = {
    label = 'Bullet Casing',
    weight = 10,
    stack = false,
    close = true,
    description = 'Bullet casing found at crime scene',
},

['evidence_blood_sample'] = {
    label = 'Blood Sample',
    weight = 50,
    stack = false,
    close = true,
    description = 'Blood sample from crime scene',
},

['evidence_fingerprint'] = {
    label = 'Fingerprint',
    weight = 10,
    stack = false,
    close = true,
    description = 'Fingerprint evidence',
},

['evidence_dna_sample'] = {
    label = 'DNA Sample',
    weight = 50,
    stack = false,
    close = true,
    description = 'DNA sample for analysis',
},

['evidence_photo_evidence'] = {
    label = 'Photo Evidence',
    weight = 10,
    stack = false,
    close = true,
    description = 'Photographic evidence',
},

['evidence_item_evidence'] = {
    label = 'Item Evidence',
    weight = 100,
    stack = false,
    close = true,
    description = 'Physical evidence item',
},

-- WEAPONS & AMMO (if not already defined)
['ammo-9'] = {
    label = '9mm Ammo',
    weight = 5,
    stack = true,
    close = true,
},

['ammo-rifle'] = {
    label = 'Rifle Ammo',
    weight = 10,
    stack = true,
    close = true,
},

['ammo-shotgun'] = {
    label = 'Shotgun Shells',
    weight = 15,
    stack = true,
    close = true,
},