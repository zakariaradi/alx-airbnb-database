# alx-airbnb-database
from graphviz import Digraph

# Create a visual ER diagram (PNG) for GitHub README preview

dot_preview = Digraph(comment='Airbnb ER Diagram', format='png')
dot_preview.attr(rankdir='LR', size='10')

# Entities
dot_preview.node('User', 'User\n(PK: user_id)')
dot_preview.node('Property', 'Property\n(PK: property_id)\nFK: host_id → User')
dot_preview.node('Booking', 'Booking\n(PK: booking_id)\nFK: property_id → Property\nFK: user_id → User')
dot_preview.node('Payment', 'Payment\n(PK: payment_id)\nFK: booking_id → Booking')
dot_preview.node('Review', 'Review\n(PK: review_id)\nFK: property_id → Property\nFK: user_id → User')
dot_preview.node('Message', 'Message\n(PK: message_id)\nFK: sender_id, recipient_id → User')

# Relationships
dot_preview.edge('User', 'Property', label='hosts')
dot_preview.edge('User', 'Booking', label='books')
dot_preview.edge('Property', 'Booking', label='has')
dot_preview.edge('Booking', 'Payment', label='paid by')
dot_preview.edge('Property', 'Review', label='has')
dot_preview.edge('User', 'Review', label='writes')
dot_preview.edge('User', 'Message', label='sends/receives')

# Save diagram
output_path_preview = '/mnt/data/airbnb_ERD_preview'
dot_preview.render(output_path_preview, format='png', cleanup=True)

output_path_preview + ".png"
