import ProverInterface from '@/components/ProverInterface'
import Card from '@/components/Card'

export default function Home() {
  return (
    <div>
      <div className='grid grid-cols-3 gap-4'>
        <Card>
          <ProverInterface />
        </Card>
      </div>
    </div>
  )
}
